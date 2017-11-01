class Gillbus
  module GetBusImage

    Gillbus.register self, :get_bus_image

    class Request < BaseRequest

      def path; '/online2/getBusImage' end

      # busId
      # Уникальный ИД заказа, переданный при отложенной продаже.
      attr_accessor :bus_id

      def params
        compact(
          busId: bus_id,
        )
      end

    end

    class Image
      extend Fields
      include UpdateAttrs

      field :url
      field :thumb_url
    end

    class Response < BaseResponse
      field :images, [Image], key: 'IMAGE'
    end
  end
end
