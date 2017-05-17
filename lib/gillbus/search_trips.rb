class Gillbus
  module SearchTrips

    Gillbus.register self, :search_trips

    class Request < BaseRequest

      def path; '/online2/searchTrips' end

      # selectedModes (не обязательный)
      # Вид транспорта, который необходимо искать.
      # @see Gillbus::BaseRequest::MODES
      attr_accessor :selected_modes

      # connectionIds (не обязательный)
      # Список предполагаемых идентификаторов пересадочных пунктов, разделенных “;”. Используется если выбран вид транспорта 8, 9.
      attr_accessor :connection_ids

      # tripFullSale (не обязательный)
      # Признак определяющий количество возвращаемых рейсов. Если true, то возвращаются заказные и регулярные рейсы. Если false, то возвращаются только регулярные рейсы.
      attr_accessor :trip_full_sale

      # fullSearch (не обязательный)
      # Признак полного поиска рейсов, который указывает когда возвращать результат.
      # Если true, то результат будет возвращен тогда, когда будет окончен поиск всех возможных рейсов.
      # Если false, то результат будет возвращен сразу, как только будут найдены первые рейсы.
      attr_accessor :full_search

      # startCityId
      # ИД пункта отправления
      attr_accessor :start_city_id

      # endCityId
      # ИД пункта прибытия
      attr_accessor :end_city_id

      # startDateSearch
      # Дата отправления, на которую будет произведен поиск рейсов.
      attr_accessor :start_date_search

      # roundTrip
      # Признак поиска рейсов туда-обратно. По-умолчанию false. Если true, то будут искаться рейсы туда-обратно.
      # Если false, то будут искаться рейсы только в одну сторону.
      attr_accessor :round_trip

      # backStartDateSearch (обязательный если roundTrip=true)
      # Дата отправления, на которую будет произведен поиск обратных рейсов.
      attr_accessor :back_start_date_search

      # ticketCount
      # Количество оформляемых билетов. От 1 до k.
      attr_accessor :ticket_count

      # passenger0studentTicket... passengerNstudentTicket (не обязательный)
      # Номер студенческого билета пассажира с порядковым номером 0... N.
      #
      # passenger0studentYea... passengerNstudentYear (не обязательный)
      # Курс, на котором учится пассажир с порядковым номером 0…N, если он студент. Для просчета более выгодной скидки.
      #
      # passenger0birthday... passengerNbirthday (не обязательный)
      # Дата рождения пассажира с порядковым номером 0...N.
      #
      # passenger0ISIC... passengerNISIC (не обязательный)
      # Номер ISIC пассажира с порядковым номером 0...N.

      # В passengers записывается структура вида
      # [
      #   {birthday: ..., student_ticket:..., student_year:..., isic:... },
      #   {birthday: ..., student_ticket:..., student_year:..., isic:... },
      # ]
      # Далее она преобразуется к формату gillbus методом passengers_data
      attr_accessor :passengers

      # waitTimeout
      # Время ожидания ответа, секунды. Если параметр установлен и поиск рейсов
      # длится дольше указанного времени, то будет возвращен пустой ответ через указанное время.
      # Параметр игнорируется, при fullSearch = true.
      attr_accessor :wait_timeout

      # onlyBranded
      # Признак отображения в результате поиска только фирменных рейсов.
      # По умолчанию отображаются все рейсы.
      attr_accessor :only_branded

      # tripOptions
      # Признак отображения списка услугрейса.
      # true - в результате будут возвращены услуги рейса.
      # По умолчанию услуги не возвращаются.
      attr_accessor :trip_options

      def params
        compact(
          selectedModes:       modes(selected_modes),
          connectionIds:       list(connection_ids),
          tripFullSale:        bool(trip_full_sale),
          fullSearch:          bool(full_search),
          startCityId:         start_city_id,
          endCityId:           end_city_id,
          startDateSearch:     date(start_date_search),
          roundTrip:           bool(round_trip),
          backStartDateSearch: date(back_start_date_search),
          ticketCount:         ticket_count,
          waitTimeout:         wait_timeout,
          onlyBranded:         bool(only_branded),
          tripOptions:         trip_options,
          **passengers_data,
        )
      end

      # В passengers_data преобразуем passengers к виду для передачи в gillbus:
      #  {
      #   :passenger0birthday=>"01.01.1990",
      #   :passenger0studentTicket=>"STUDENTTICKET#1",
      #   :passenger0studentYear=>1,
      #   :passenger0ISIC=>"ISIC#1",
      #   :passenger1birthday=>"02.02.1990",
      #   :passenger1studentTicket=>"STUDENTTICKET#2",
      #   :passenger1studentYear=>2,
      #   :passenger1ISIC=>"ISIC#2"
      # }
      def passengers_data
        (passengers || []).map.with_index do |p, i|
          PassengerDiscount.wrap(p).params("passenger#{i}")
        end.reduce({}, :merge)
      end

    end

    class Response < BaseResponse
      field :completed, :bool
      field :trips, [Trip], key: 'TRIP'
    end

  end
end
