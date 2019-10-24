class Gillbus
  module GetRequiredFields
    Gillbus.register self, :get_required_fields

    class Request < BaseRequest
      def path; '/online2/getRequiredFields' end

      attr_accessor :trip_id

      def params
        compact(
          tripId: trip_id,
        )
      end
    end

    class Response < BaseResponse
      field :dictionary, :bool_dict
      field :baggage, Baggage

      parser do
        def bool_dict(val)
          return unless val
          result = {}
          val.each do |k, v|
            result[k.downcase.to_sym] = bool(v)
          end
          result
        end
      end
    end
  end
end
