class Gillbus
  # Получение маршрута следования (getTripSegments)
  # Возвращает список остановочных пунктов следования рейса
  # Если список остановочных пунктов отсутствует, то ресурс не предоставляет возможности получения маршрута следования.
  module GetTripSegments
    Gillbus.register self, :get_trip_segments

    class Request < BaseRequest
      def path; '/online2/getTripSegments' end

      # tripId
      # ИД рейса, для которого нужно получить маршрут
      attr_accessor :trip_id

      def params
        { tripId: trip_id }
      end
    end

    class Response < BaseResponse
      field :points, [Point], key: 'POINT'
    end
  end
end
