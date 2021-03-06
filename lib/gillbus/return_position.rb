class Gillbus
  module ReturnPosition
    Gillbus.register self, :return_position

    class Request < BaseRequest
      def path; '/online2/returnPosition' end

      # ticketCount
      # Кол-во возвращаемых билетов. 1..k
      attr_accessor :ticket_count

      # Номера билетов с порядковым номером
      attr_accessor :system_numbers

      def params
        numbers = system_numbers.map.with_index do |num, i|
          [:"systemNumber#{i}", num]
        end.to_h

        compact(
          ticketCount: ticket_count,
          **numbers,
        )
      end
    end

    class Response < BaseResponse
      class ReturnPosition
        extend Fields

        field :system_number
        field :confirmation, :yesno_bool
        field :reason_id
        field :date
        field :failures
        field :returned_amount
        field :detained_amount
      end

      field :return_positions, [ReturnPosition], key: 'RETURN_POSITION'
    end
  end
end
