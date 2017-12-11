class Gillbus
  module FindOrder

    Gillbus.register self, :find_order

    class Request < BaseRequest
      def path; '/online2/findOrder' end

      # orderId
      # Уникальный ИД заказа, переданный при отложенной продаже.
      attr_accessor :order_id

      # orderNumber
      # Номер заказа полученный при создании отложенной продажи.
      attr_accessor :order_number

      # Язык формирования данных.
      attr_accessor :locale

      def params
        compact(
          orderId: order_id,
          orderNumber: order_number,
          locale: translated_locale(locale),
        )
      end
    end

    class Response < BaseResponse
      field :tickets, [Ticket], key: 'TICKET'
    end

  end
end
