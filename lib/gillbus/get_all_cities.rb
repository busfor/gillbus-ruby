class Gillbus
  module GetAllCities

    Gillbus.register self, :get_all_cities

    class Request < BaseRequest
      def path; '/online2/getAllCities' end
    end

    class City
      extend Fields
      include UpdateAttrs
      field :id
      field :name
      field :country_id
      field :country_name
      field :name_full
    end

    class Response < BaseResponse
      field :cities, [City], key: 'CITY'
    end

  end
end
