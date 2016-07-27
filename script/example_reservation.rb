#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gillbus'
require 'pry'
require 'securerandom'

GILLBUS_SERVER = "http://mdc.demo.gillbus.com"
GILLBUS_PASSWORD = "3DVG/x1AOk+xwNlAEXytMCxZMsb73r39DOg97k8b8c4YaMrlOar071diefS0IyZT"

require 'logger'

driver = Faraday.new(url: GILLBUS_SERVER) { |c|
  c.response :logger, Logger.new(STDOUT), bodies: true
  c.request :url_encoded
  c.adapter Faraday.default_adapter
}

g = Gillbus.new(driver: driver).login(
  password: GILLBUS_PASSWORD,
  locale: :ru
)

# getCities

cities = g.get_cities.cities

kiiv_id = cities.find {|c| c.name == "Киев" }.id
lviv_id = cities.find {|c| c.name == "Львов" }.id


# searchTrips

search_date = Date.today + 7
trips = g.search_trips(
  start_city_id: kiiv_id,
  end_city_id: lviv_id,
  start_date_search: search_date,
  ticket_count: 2,
  selected_modes: 1,
).trips

trip_id = trips.find { |trip| trip.reservation_enabled == true }.id

# lockSeats

tl = g.lock_seats(
  trip_id: trip_id,
).time_limit

# ticketsBooking
order_id = SecureRandom.uuid

puts "making order: #{order_id}"
passengers = [
  { first_name: 'Иван', last_name: 'Иванов' },
  { first_name: 'Петр', last_name: 'Петров' }
]

rt = g.reserve_tickets(
  order_id: order_id,
  mail_address: 'ivan@mail.ru',
  note: 'test',
  passengers: passengers
)
ticket_numbers = rt.tickets.map(&:ticket_number)

# relogging again

g = Gillbus.new(driver: driver).login(password: GILLBUS_PASSWORD, locale: :ru)

# buyBooking
response = g.buy_booking(
  ticket_count: 2,
  ticket_numbers: ticket_numbers,
  order_ids: [order_id, order_id]
)
p "confirmation: " + response.ticket.confirmation.inspect
p "ticket_numbers: " + response.ticket.position_numbers.inspect

# getOrderTicket
ot = g.get_order_ticket order_id: order_id, base64: true

filename = order_id + ".pdf"
puts "saving " + filename
File.open filename, 'wb' do |f|
  f << ot.ticket
end
