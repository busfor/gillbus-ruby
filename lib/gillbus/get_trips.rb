class Gillbus
  module GetTrips

    Gillbus.register self, :get_trips

    class Request < BaseRequest
      def path; '/online2/getTrips' end
    end

    Response = Gillbus::SearchTrips::Response

  end
end
