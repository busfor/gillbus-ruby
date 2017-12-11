require 'base64'
class Gillbus
  module GetOrderTicket
    Gillbus.register self, :get_order_ticket

    class Request < BaseRequest
      def path; '/online2/getOrderTicket' end

      # orderId
      # Уникальный ИД заказа, переданный при отложенной продаже.
      attr_accessor :order_id

      # removeAd
      # Признак удаления логотипа Gillbus из билета. true – удалить логотип.
      # По умолчанию false.
      attr_accessor :remove_ad

      # orderNumber
      # Номер заказа полученный при создании отложенной продажи.
      attr_accessor :order_number

      # base64 (не обязательный)
      # Признак получения билета заказа в виде строки Base64.
      # true – билет заказа будет возвращен как строка Base64.
      # По умолчанию false.
      # Важно: надо передать true, парсер ответа ожидает этого.
      # Иначе можно получить невалидный xml
      attr_accessor :base64

      # Тип возвращаемого документа. Например, "ticket"
      attr_accessor :as

      # locale (не обязательный)
      # Язык формирования данных.
      attr_accessor :locale

      def params
        compact(
          orderId: order_id,
          removeAd: remove_ad,
          orderNumber: order_number,
          base64: base64,
          as: as,
          locale: translated_locale(locale),
        )
      end
    end

    class Response < BaseResponse
      field :ticket, :ticket

      parser do
        def ticket(val)
          Base64.decode64(val)
        end
      end
    end
  end
end
