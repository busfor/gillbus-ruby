class Gillbus
  module GetAllCities

    Gillbus.register self, :get_all_cities

    class Request < BaseRequest
      def path; '/online2/getAllCities' end

      # completeListSities (не обязательный, по умолчанию false)
      # Признак получения полного списка населённых пунктов.
      # Если установлен в true, будет возвращён полный список НП
      # (за исключением ограничений на уровне консолидатора).
      attr_accessor :complete_list_cities

      def params
        compact(
          completeListSities: bool(complete_list_cities),
        )
      end
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
