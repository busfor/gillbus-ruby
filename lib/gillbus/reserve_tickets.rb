class Gillbus
  module ReserveTickets

    Gillbus.register self, :reserve_tickets

    class Request < Gillbus::TicketsBooking::Request
      def path; '/online2/reserveTickets' end
    end

    Response = Gillbus::TicketsBooking::Response

  end
end
