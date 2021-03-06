require 'gillbus/version'
require 'faraday'

class Gillbus
  # driver: e.g. Faraday.new(url: 'http://demo.gillbus.com')
  def initialize(driver:, session_id: nil, timezone: nil)
    @driver = driver
    @session_id = session_id
    @timezone = timezone
  end

  # Faraday instance
  attr_reader :driver
  # JSESSIONID сессии API gillbus
  attr_accessor :session_id
  attr_accessor :timezone

  def login(password:, locale: nil)
    session_login password: password, locale: locale
    self
  end

  def self.register(klass, method_name)
    define_method method_name do |*args|
      request_class = klass::Request
      response_class = klass::Response
      request = request_class.new(*args)
      headers = {}
      headers['Cookie'] = self.class.make_cookies(session_id) if session_id
      headers['Accept-Encoding'] = 'gzip'
      headers['Host'] = driver.host
      request_time_start = Time.now
      http_response = driver.public_send(request.method, request.path, request.params, headers)
      request_time_end = Time.now
      result = response_class.parse_string(http_response.body.force_encoding('utf-8'), timezone: timezone)
      cookie_string = http_response.headers['Set-Cookie']
      if cookie_string
        self.session_id = self.class.make_session_id(CGI::Cookie.parse(cookie_string))
      end
      result.session_id = session_id
      result.request_time = request_time_end - request_time_start
      result
    end
  end

  def self.make_cookies(session_id)
    if session_id.include?('|')
      session_id, gclb = session_id.split('|')
      "JSESSIONID=#{session_id}; GCLB=#{gclb}"
    else
      "JSESSIONID=#{session_id}"
    end
  end

  def self.make_session_id(parsed_cookies)
    gclb = parsed_cookies['GCLB'].first
    session_id = parsed_cookies['JSESSIONID'].first
    if gclb.present?
      [session_id, gclb].join('|')
    else
      session_id
    end
  end

  require 'monetize'
  require 'gillbus/helpers/fields'
  require 'gillbus/helpers/update_attrs'
  require 'gillbus/helpers/parser'

  require 'gillbus/structs/trip_service'
  require 'gillbus/structs/tickets_option'
  require 'gillbus/structs/trip_options'
  require 'gillbus/structs/point'
  require 'gillbus/structs/tariff/return_cause'
  require 'gillbus/structs/tariff'
  require 'gillbus/structs/bus_photo'
  require 'gillbus/structs/segment'
  require 'gillbus/structs/timetable_segment'
  require 'gillbus/structs/trip'
  require 'gillbus/structs/timetable_trip'

  require 'gillbus/structs/commission'
  require 'gillbus/structs/return_cause'
  require 'gillbus/structs/ticket'

  require 'gillbus/structs/seat'
  require 'gillbus/structs/item'
  require 'gillbus/structs/carrier'
  require 'gillbus/structs/nearby_cities_trip'
  require 'gillbus/structs/luggage'

  require 'gillbus/parse_error'
  require 'gillbus/base_request'
  require 'gillbus/base_response'

  require 'gillbus/structs/passenger_discount'

  require 'gillbus/session_login'
  require 'gillbus/get_countries'
  require 'gillbus/get_cities'
  require 'gillbus/get_all_cities'
  require 'gillbus/get_time_table'
  require 'gillbus/get_dates_new'
  require 'gillbus/search_trips'
  require 'gillbus/search_nearby_trips'
  require 'gillbus/get_trips'
  require 'gillbus/get_trip_seats'
  require 'gillbus/get_bus_image'
  require 'gillbus/get_trip_segments'
  require 'gillbus/get_required_fields'
  require 'gillbus/lock_seats'
  require 'gillbus/unlock_seats'
  require 'gillbus/tickets_booking'
  require 'gillbus/reserve_tickets'
  require 'gillbus/buy_booking'
  require 'gillbus/buy_tickets'
  require 'gillbus/cancel_order'
  require 'gillbus/get_order_ticket'
  require 'gillbus/find_order'
  require 'gillbus/get_order_status'
  require 'gillbus/logout'
  require 'gillbus/return_position'
  require 'gillbus/return_position_forced'
  require 'gillbus/get_carriers'
end
