class Gillbus
  module GetDatesNew

    Gillbus.register self, :get_dates_new

    class Request < BaseRequest
      def path; '/online2/getDatesNew' end

      attr_accessor :start_city_id
      attr_accessor :end_city_id
      attr_accessor :start_date_search
      attr_accessor :end_date_search
      attr_accessor :oneway_trip_date
      attr_accessor :selected_modes

      def params
        compact(
          startCityId: start_city_id,
          endCityId: end_city_id,
          startDateSearch: date(start_date_search),
          endDateSearch: date(end_date_search),
          onewayTripDate: date(oneway_trip_date),
          selectedModes: modes(selected_modes),
        )
      end
    end

    class Response < BaseResponse
      field :items, [Item], key: 'ITEM'
    end

  end
end
