class Gillbus
  module GetCountries
    Gillbus.register self, :get_countries

    class Request < BaseRequest
      def path; '/online2/getCountries' end
    end

    class Country
      extend Fields
      include UpdateAttrs
      field :id
      field :name
    end

    class Response < BaseResponse
      field :countries, [Country], key: 'COUNTRY'
    end
  end
end
