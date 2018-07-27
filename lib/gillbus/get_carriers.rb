class Gillbus
  module GetCarriers
    Gillbus.register self, :get_carriers

    class Request < BaseRequest
      def path; '/online2/getCarriers' end
    end

    class Carrier
      extend Fields
      include UpdateAttrs
      field :id
      field :name
      field :inn
    end

    class Response < BaseResponse
      field :carriers, [Carrier], key: 'CARRIER'
    end
  end
end
