class Gillbus
  module BuyTickets
    Gillbus.register self, :buy_tickets

    class Request < BaseRequest
      def path; '/online2/buyTickets' end

      # orderId
      # Уникальный ИД заказа, переданный при отложенной продаже.
      attr_accessor :order_id

      def params
        { orderId: order_id }
      end
    end

    class Response < BaseResponse
      class TicketConfirmation
        extend Fields
        # String. пока не выяснится, в какой таймзоне это значение и зачем
        field :date
        field :order_id
        field :confirmation, :yesno_bool
      end

      field :ticket, TicketConfirmation
    end
  end
end
