class Gillbus
  module LockSeats
    Gillbus.register self, :lock_seats

    class Request < BaseRequest
      def path; '/online2/lockSeats' end

      # tripId
      # ИД рейса, для которого нужно получить карту мест
      attr_accessor :trip_id

      # carriageId (не обязательный)
      # ИД вагона, для которого нужно получить карту мест.
      # По- умолчанию первый попавшийся. Только для железнодорожных рейсов.
      attr_accessor :carriage_id

      # backCarriageId (не обязательный)
      # ИД вагона обратного рейса, для которого нужно получить карту мест.
      # По-умолчанию первый попавшийся. Только для железнодорожных рейсов.
      attr_accessor :back_carriage_id

      # segment0carriageId...segmentNcarriageId (не обязательный)
      # ИД вагона сегмента рейса с порядковым нормеом 0...N, для которого нужно получить карту мест.
      # По-умолчанию первый попавшийся. Только для железнодорожных рейсов.

      # seatId0...seatIdN (не обязательный)
      # ИД места с порядковым номером 0...N, которое нужно заблокировать.
      attr_accessor :seat_ids

      # backSeatId0...backSeatIdN (не обязательный)
      # ИД места с порядковым номером 0...N, которое нужно заблокировать на обратный рейс.
      attr_accessor :back_seat_ids

      # segment0seatId0... segmentMseatIdN (не обязательный)
      # ИД места с порядковым номером 0...N, которое нужно заблокировать на сегмент рейса с порядковым номером 0...M.
      attr_accessor :segments_seat_ids

      def params
        seats = Array(seat_ids).map.with_index { |id, n| [:"seatId#{n}", id] }.to_h
        back_seats = Array(back_seat_ids).map.with_index { |id, n| [:"backSeatId#{n}", id] }.to_h
        segments_seats = Hash(segments_seat_ids).map do |segment, seat_ids|
          Array(seat_ids).map.with_index { |id, n| [:"segment#{segment}seatId#{n}", id] }.to_h
        end.reduce(&:merge).to_h

        compact(
          tripId: trip_id,
          carriageId: carriage_id,
          backCarriageId: back_carriage_id,
          **seats,
          **back_seats,
          **segments_seats,
        )
      end
    end

    class Response < BaseResponse
      # seat lock, time limit, in seconds
      field :time_limit, :milliseconds
      # [{Symbol => Boolean}] необходимые для ввода типы документов?
      field :dictionary, :bool_dict

      parser do
        def milliseconds(val)
          return unless val
          val.to_i / 1000
        end

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
