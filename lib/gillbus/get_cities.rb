class Gillbus
  module GetCities
    Gillbus.register self, :get_cities

    class Request < BaseRequest
      def path; '/online2/getCities' end

      attr_accessor :start_city_id

      def params
        {
          startCityId: start_city_id,
        }
      end
    end

    class City
      extend Fields
      include UpdateAttrs
      field :id
      field :name
      field :country_id
      field :country_name
    end

    class Response < BaseResponse
      field :cities, [City], key: 'CITY'
    end
  end
end
