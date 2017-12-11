#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gillbus'
require 'pry'
require 'securerandom'

GILLBUS_SERVER = 'http://mdc.demo.gillbus.com'
GILLBUS_PASSWORD = '3DVG/x1AOk+xwNlAEXytMCxZMsb73r39DOg97k8b8c4YaMrlOar071diefS0IyZT'

require 'logger'

driver = Faraday.new(url: GILLBUS_SERVER) { |c|
  c.response :logger, Logger.new(STDOUT), bodies: true
  c.request :url_encoded
  c.adapter Faraday.default_adapter
}

g = Gillbus.new(driver: driver).login(
  password: GILLBUS_PASSWORD,
  locale: :ru,
)

# getCities

cities = g.get_cities.cities

kiiv_id = cities.find { |c| c.name == 'Киев' }.id
odessa_id = cities.find { |c| c.name == 'Львов' }.id


# searchTrips

search_date = Date.today + 7
trips = g.search_trips(
  start_city_id: kiiv_id,
  end_city_id: odessa_id,
  start_date_search: search_date,
  ticket_count: 2,
  selected_modes: 1,
).trips

trip_id = trips.find { |trip| trip.reservation_enabled == true }.id

# lockSeats

tl = g.lock_seats(trip_id: trip_id).time_limit

# ticketsBooking
order_id = SecureRandom.uuid

puts "making order: #{order_id}"
passengers = [
  { first_name: 'Иван', last_name: 'Иванов' },
  { first_name: 'Петр', last_name: 'Петров' },
]

rt = g.reserve_tickets(
  order_id: order_id,
  mail_address: 'ivan@mail.ru',
  note: 'test',
  passengers: passengers,
)

# отмена брони
order_number = rt.tickets.first.order_number
canceling = g.cancel_order(order_number: order_number, cancel_reason: 'no_reason')
puts 'canceling: ' + canceling.inspect
puts 'success? ' + canceling.order_cancel.confirmation.inspect
