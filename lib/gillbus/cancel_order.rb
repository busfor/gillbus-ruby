class Gillbus
  module CancelOrder
    Gillbus.register self, :cancel_order

    class Request < BaseRequest
      def path; '/online2/cancelOrder' end

      # orderNumber
      # The order number
      attr_accessor :order_number

      # cancelReason
      # Cancellation reason
      attr_accessor :cancel_reason

      def params
        compact(
          orderNumber: order_number,
          cancelReason: cancel_reason,
        )
      end
    end


    class Response < BaseResponse
      class OrderCancel
        extend Fields

        # The order number
        field :number

        # The cancellation reason
        field :reason

        # The flag, which indicates successful order cancellation.
        field :confirmation, :yesno_bool

        # The request’s performing date
        # String. FIXME (Kiiv timezone?)
        field :date
      end

      field :order_cancel, OrderCancel
    end
  end
end
