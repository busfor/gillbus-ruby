class Gillbus
  module GetTimeTable
    Gillbus.register self, :get_time_table

    class Request < BaseRequest
      def path; '/online2/getTimeTable' end

      attr_accessor :locale
      attr_accessor :start_city_id
      attr_accessor :end_city_id
      attr_accessor :start_date_search
      attr_accessor :end_date_search

      def params
        compact(
          locale: translated_locale(locale),
          startCityId: start_city_id,
          endCityId: end_city_id,
          startDateSearch: date(start_date_search),
          endDateSearch: date(end_date_search),
        )
      end
    end

    class Response < BaseResponse
      field :trips, [TimetableTrip], key: 'TRIP'
    end
  end
end
