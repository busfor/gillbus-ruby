class Gillbus
  module UnlockSeats
    Gillbus.register self, :unlock_seats

    class Request < BaseRequest
      def path; '/online2/unlockSeats' end
    end

    # TODO: is it empty?
    class Response < BaseResponse
    end
  end
end
