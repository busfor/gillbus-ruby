class Gillbus
  module GetOrderStatus

    Gillbus.register self, :get_order_status

    class Request < BaseRequest
      def path; '/online2/getOrderStatus' end

      # orderNumber
      # Номер заказа или массив заказов, полученных при создании отложенной продажи.
      attr_accessor :order_number

      def params
        compact(
          orderNumber: order_number.is_a?(Array) ? order_number.join(';') : order_number,
        )
      end
    end

    class Response < BaseResponse
      field :tickets, [Ticket], key: 'TICKET'
    end

  end
end
