#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gillbus'
require 'pry'
require 'logger'
require 'securerandom'

GILLBUS_SERVER = "http://mdc.demo.gillbus.com"
GILLBUS_PASSWORD = "3DVG/x1AOk+xwNlAEXytMCxZMsb73r39DOg97k8b8c4YaMrlOar071diefS0IyZT"

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
praga_id = cities.find {|c| c.name == "Прага" }.id


# searchTrips

tomorrow = Date.today + 1
trips = g.search_trips(
  start_city_id: kiiv_id,
  end_city_id: praga_id,
  start_date_search: tomorrow,
  ticket_count: 2,
  selected_modes: [ :bus, :connections ],
  ],
).trips

trip_id = trips.find { |trip| trip.segments.present? }.id

# getTripSeats

seat_map = g.get_trip_seats(trip_id: trip_id)
selected_seat_ids = seat_map.segments.map do |k, v|
  [k, v.select(&:free?).sample(2).map(&:id)]
end.to_h

# lockSeats

tl = g.lock_seats(
  trip_id: trip_id,
  segments_seat_ids: selected_seat_ids,
).time_limit

# ticketsBooking
order_id = SecureRandom.uuid

puts "making order: #{order_id}"
passengers = [
  { first_name: 'Иван', last_name: 'Иванов', passport: "123" },
  { first_name: 'Петр', last_name: 'Петров', passport: "123" }
]

tb = g.tickets_booking(
  order_id: order_id,
  mail_address: 'ivan@mail.ru',
  note: 'test',
  passengers: passengers
)

# relogging again

g = Gillbus.new(driver: driver).login(password: GILLBUS_PASSWORD, locale: :ru)

# buyTickets
puts "confirmation: " + g.buy_tickets(order_id: order_id).ticket.confirmation.inspect

# getOrderTicket
ot = g.get_order_ticket order_id: order_id, base64: true

filename = order_id + ".pdf"
puts "saving " + filename
File.open filename, 'wb' do |f|
  f << ot.ticket
end

