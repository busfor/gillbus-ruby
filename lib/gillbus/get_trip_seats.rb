class Gillbus
  module GetTripSeats
    Gillbus.register self, :get_trip_seats

    class Request < BaseRequest
      def path; '/online2/getTripSeats' end

      # tripId
      # ИД рейса, для которого нужно получить карту мест
      attr_accessor :trip_id

      # carriageId (не обязательный)
      # ИД вагона, для которого нужно получить карту мест.
      # По- умолчанию первый попавшийся.
      # Только для железнодорожных рейсов.
      attr_accessor :carriage_id

      # backCarriageId (не обязательный)
      # ИД вагона обратного рейса, для которого нужно получить карту мест.
      # По-умолчанию первый попавшийся.
      # Только для железнодорожных рейсов.
      attr_accessor :back_carriage_id

      # segment0carriageId...segmentNcarriageId (не обязательный)
      # ИД вагона сегмента рейса с порядковым нормеом 0...N, для которого нужно получить карту мест.
      # По-умолчанию первый попавшийся. Только для железнодорожных рейсов.

      def params
        compact(
          tripId: trip_id,
          carriageId: carriage_id,
          backCarriageId: back_carriage_id,
        )
      end
    end

    class Response < BaseResponse
      SEGMENT_REGEX = /SEGMENT_(?<number>\d+)_SEAT/

      field :seats, [Seat], key: 'SEAT'
      field :back_seats, [Seat], key: 'BACK_SEAT' # для round_trip offers

      field :segments, :segments, key: SEGMENT_REGEX

      parser do
        def segments(val)
          return {} unless val.present?

          max_segment_number = val.keys.max.match(SEGMENT_REGEX)[:number].to_i

          [*0..max_segment_number].each_with_object({}) do |segment, hash|
            seats = val["SEGMENT_#{segment}_SEAT"].to_a
            hash[segment] = seats.map { |seat| Seat.parse(seat) }.presence || []
          end
        end
      end
    end
  end
end
