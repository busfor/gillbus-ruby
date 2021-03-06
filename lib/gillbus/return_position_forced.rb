class Gillbus
  module ReturnPositionForced
    Gillbus.register self, :return_position_forced

    class Request < ::Gillbus::ReturnPosition::Request
      def path; '/online2/ReturnPositionForced'; end
    end

    class Response < ::Gillbus::ReturnPosition::Response
      class ReturnPositionForced < ::Gillbus::ReturnPosition::Response::ReturnPosition
      end

      field :return_positions, [::Gillbus::ReturnPosition::Response::ReturnPosition], key: 'RETURN_POSITION'
    end
  end
end
