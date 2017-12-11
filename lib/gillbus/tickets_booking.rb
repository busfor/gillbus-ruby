class Gillbus
  module TicketsBooking

    Gillbus.register self, :tickets_booking

    class Request < BaseRequest
      def path; '/online2/ticketsBooking' end

      # orderId
      # Сгенерированный уникальный ИД заказа.
      attr_accessor :order_id

      # terminalNumber (не обязательный)
      # Номер терминала, с которого выполняется команда.
      attr_accessor :terminal_number

      # applyDiscount (не обязательный)
      # Если при поиске рейсов не были указаны скидочные данные но есть возможность их применить при оформлении отложенной продажи (параметр CAN_DISCOUNT = true при поиске рейсов), то для применения скидочных данных необходимо этот параметр установить в true. Если на оформляемый рейс действуют скидки, то стоимость тарифа может быть пересчитана по переданным данным в параметрах passenger(0 - N)studentTicket, passenger(0 - N)birthday, passenger(0 - N)ISIC. По умолчанию false (скидочные данные не применяются ).
      attr_accessor :apply_discount

      # paymentMethod (не обязательный)
      # Способ оплаты заказа.
      attr_accessor :payment_method

      # 1 – наличный;
      METHOD_CASH = 1
      # 2 – кредитной карточкой;
      METHOD_CARD = 2
      # 3 – безналичный;
      METHOD_NOCASH = 3
      # 4 – сервисный;
      METHOD_SERVICE = 4
      # 5 – эквайринг.
      METHOD_ACQUIRING = 5
      # По умолчанию 3.

      # phoneNumber (не обязательный)
      # Номер телефона пассажира.
      attr_accessor :phone_number

      # mailAddress (не обязательный)
      # Адрес электронной почты пассажира. Если указан, то на него будет отправлен маршрутный лист соответствующий форме утвержденной с перевозчиком.
      attr_accessor :mail_address

      # note (не обязательный)
      # Примечания.
      attr_accessor :note

      # ticketLocale (не обязательный)
      # Язык, на котором будут возвращены данные для печати билета. Если язык не передан или ошибочный, то будет установлен язык переданный при вызове команды входа в систему.
      # rus – русский;
      # ukr – украинский; lat – английский.
      attr_accessor :ticket_locale

      # список пассажиров
      attr_accessor :passengers

      # отправлять ли email с листом бронирования пользователю
      attr_accessor :send_to

      def params
        pax = (passengers || []).map.with_index { |p, i| Passenger.new(p).params("passenger#{i}") }.reduce({}, :merge)
        compact(
          orderId: order_id,
          terminalNumber: terminal_number,
          applyDiscount: apply_discount,
          paymentMethod: payment_method,
          phoneNumber: phone_number,
          mailAddress: mail_address,
          note: note,
          ticketLocale: translated_locale(ticket_locale),
          sendTo: send_to,
          **pax
        )

      end

      # not a request, just a record for BookTickets
      class Passenger < BaseRequest
        # passenger0studentTicket... passengerNstudentTicket (не обязательный)
        # Номер студенческого билета пассажира с порядковым номером 0... N.

        # passenger0birthday... passengerNbirthday (обязательный для авиаперевозки)
        # Дата рождения пассажира с порядковым номером 0...N.
        attr_accessor :birthday

        # passenger0ISIC...passengerNISIC (не обязательный)
        # Номер ISIC пассажира с порядковым номером 0...N.
        attr_accessor :isic

        # passenger0firstName... passengerNfirstName (не обязательный)
        # Имя пассажира с порядковым номером 0...N.
        attr_accessor :first_name

        # passenger0lastName... passengerNlastName (не обязательный)
        # Фамилия пассажира с порядковым номером 0...N.
        attr_accessor :last_name

        # passenger0middleName... passengerNmiddleName (не обязательный)
        # Отчество пассажира с порядковым номером 0...N.
        attr_accessor :second_name

        # passenger0tariffShortName... passengerNtariffShortName (не обязательный)
        # Краткое обозначение тарифа, полученное при поиске рейсов в списке тарифов, по указанным passenger0studentTicket, passenger0birthday, passenger0ISIC.
        attr_accessor :tariff_short_name

        # passenger0tariffCost... passengerNtariffCost (не обязательный)
        # Стоимость тарифа, полученное при поиске рейсов в списке тарифов, с кратким обозначением passenger0tariffShortName с порядковым номером 0...N.
        attr_accessor :tariff_cost

        # passenger0documentType... passengerNdocumentType (не обязательный)
        # Тип удостоверения личности (для определения типа документа, номер которого передан в параметре passport).
        # Возможные значения:
        # :passport              1 - паспорт
        # :military_card         2 - военный билет
        # :foreign_document      3 - иностранный документ
        # :foreign_passport      4 - заграничный паспорт
        # :seaman_passport       6 - паспорт моряка
        # :birth_certificate     7 - свидетельство о рождении
        # :ussr_passport         8 - паспорт формы СССР
        attr_accessor :document_type

        # passenger0passport... passengerNpassport (обязательный для авиаперевозки)
        # Паспортные данные пассажира с порядковым номером 0...N.
        attr_accessor :passport

        # passenger0passportExpireDate... passengerNpassportExpireDate (обязательный для авиаперевозки)
        # Дата окончания действия паспорта пассажира с порядковым номером 0...N.
        attr_accessor :passport_expire_date

        # passenger0citizenship... passengerNcitizenship (обязательный для авиаперевозки)
        # Гражданство пассажира с порядковым номером 0...N. 2-х буквенный код страны, пример, Украина – UA.
        attr_accessor :citizenship

        # passenger0gender... passengerNgender (обязательный для авиаперевозки)
        # Пол пассажира с порядковым номером 0...N. M – мужской, F – женский.
        attr_accessor :gender

        # passenger0discountValue... passengerNdiscountValue (не обязательный)
        # Величина скидки в валюте продажи для пассажира с порядковым номером 0…N.
        attr_accessor :discount

        def params(prefix="")
          compact(
            birthday: date(birthday),
            ISIC: isic,
            firstName: first_name,
            lastName: last_name,
            middleName: second_name,
            tariffShortName: tariff_short_name,
            tariffCost: tariff_cost,
            documentType: document_type_to_int(document_type),
            passport: passport,
            passportExpireDate: passport_expire_date,
            citizenship: citizenship,
            gender: gender,
            discountValue: discount.to_f.to_s,
          ).map {|k, v| [:"#{prefix}#{k}", v] }.to_h
        end

        def document_type_to_int(value)
          {
            passport: 1,
            military_card: 2,
            foreign_document: 3,
            foreign_passport: 4,
            seaman_passport: 6,
            birth_certificate: 7,
            ussr_passport: 8,
          }[value.try(:to_sym)]
        end
      end
    end

    class Response < BaseResponse
      field :tickets, [Ticket], key: 'TICKET'
    end

  end
end
