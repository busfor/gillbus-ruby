class Gillbus
  module GetBusImage

    Gillbus.register self, :get_bus_image

    class Request < BaseRequest

      def path; '/online2/GetBusImage' end

      def method; :get end

      # busId
      # Уникальный ИД заказа, переданный при отложенной продаже.
      attr_accessor :bus_id

      def params
        compact(
          busId: bus_id,
        )
      end

    end

    class Response < BaseResponse
      field :image_urls, [:string], key: 'URL'
    end

  end

end
