class Gillbus
  module ReturnPositionForced
    Gillbus.register self, :return_position_forced

    class Request < ::Gillbus::ReturnPosition::Request
      def path; '/online2/returnPositionForced'; end
    end

    class Response < BaseResponse
      class ReturnPositionForced < ::Gillbus::ReturnPosition::Response::ReturnPosition
      end
    end
  end
end
