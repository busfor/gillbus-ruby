class Gillbus
  module SessionLogin
    Gillbus.register self, :session_login

    class Request < BaseRequest
      def initialize(password:, locale: nil)
        super
      end

      attr_accessor :password
      attr_accessor :locale

      def path
        "/online2/sessionLogin/online/#{@password}"
      end

      def params
        compact(locale: translated_locale(locale))
      end
    end

    class Response < BaseResponse
      field :logged, :bool
    end
  end
end
