class Gillbus
  module SearchTripNearbyCities
    Gillbus.register self, :search_nearby_cities_trips

    class Request < BaseRequest
      def path; '/online2/searchTripNearbyCities' end

      # startCityId
      # ИД пункта отправления
      attr_accessor :start_city_id

      # endCityId
      # ИД пункта прибытия
      attr_accessor :end_city_id

      # startDateSearch
      # Дата отправления, на которую будет произведен поиск рейсов.
      attr_accessor :start_date_search

      # ticketCount
      # Количество оформляемых билетов. От 1 до k.
      attr_accessor :ticket_count

      def params
        compact(
          startCityId: start_city_id,
          endCityId: end_city_id,
          startDateSearch: date(start_date_search),
          ticketCount: ticket_count,
        )
      end
    end

    class Response < BaseResponse
      field :completed, :bool
      field :trips, [NearbyCitiesTrip], key: 'TRIP', root: 'NEARBY_CITIES'
    end
  end
end
