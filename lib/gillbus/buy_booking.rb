class Gillbus
  module BuyBooking
    Gillbus.register self, :buy_booking

    class Request < BaseRequest
      def path; '/online2/buyBooking' end

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

      # ticketCount
      # Кол-во выкупаемых билетов. 1..k
      attr_accessor :ticket_count

      # Номера билетов с порядковым номером
      attr_accessor :ticket_numbers

      attr_accessor :order_ids

      def params
        numbers = ticket_numbers.map.with_index do |num, i|
          [:"ticketNumber#{i}", num]
        end.to_h

        orders = order_ids.map.with_index do |val, i|
          [:"orderId#{i}", val]
        end.to_h

        compact(
          paymentMethod: payment_method,
          ticketCount: ticket_count,
          **numbers,
          **orders
        )
      end
    end

    class Response < BaseResponse
      class TicketConfirmation
        extend Fields

        field :number, :int
        # String. пока не выяснится, в какой таймзоне это значение и зачем
        field :date
        field :order_id
        field :confirmation, :yesno_bool
        field :position_numbers, [:int], key: 'POSITION_NUMBER'
      end

      field :ticket, TicketConfirmation
    end
  end
end
