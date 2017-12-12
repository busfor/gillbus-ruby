class Gillbus
  module Logout
    Gillbus.register self, :logout

    class Request < BaseRequest
      def path; '/online2/logout' end
    end

    class Response < BaseResponse
      field :logout, :bool
    end
  end
end
