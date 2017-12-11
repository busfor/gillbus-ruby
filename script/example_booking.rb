#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gillbus'
require 'pry'
require 'logger'
require 'securerandom'

GILLBUS_SERVER = 'http://mdc.demo.gillbus.com'.freeze
GILLBUS_PASSWORD = '3DVG/x1AOk+xwNlAEXytMCxZMsb73r39DOg97k8b8c4YaMrlOar071diefS0IyZT'.freeze

driver = Faraday.new(url: GILLBUS_SERVER) do |c|
  c.response :logger, Logger.new(STDOUT), bodies: true
  c.request :url_encoded
  c.adapter Faraday.default_adapter
end

g = Gillbus.new(driver: driver).login(
  password: GILLBUS_PASSWORD,
  locale: :ru,
)

# getCities

cities = g.get_cities.cities

kiiv_id = cities.find { |c| c.name == 'Киев' }.id
lviv_id = cities.find { |c| c.name == 'Львов' }.id

# searchTrips

tomorrow = Date.today + 1
trips = g.search_trips(
  start_city_id: kiiv_id,
  end_city_id: lviv_id,
  start_date_search: tomorrow,
  ticket_count: 2,
  passengers: [
    { birthday: Date.new(1983, 4, 19) },
    { birthday: Date.new(2007, 10, 15) },
  ],
).trips

trip_id = trips.first.id

# lockSeats

tl = g.lock_seats(trip_id: trip_id).time_limit

# ticketsBooking
order_id = SecureRandom.uuid

puts "making order: #{order_id}"
passengers = [
  { first_name: 'Иван', last_name: 'Иванов', passport: '123' },
  { first_name: 'Петр', last_name: 'Петров', passport: '123' },
]

tb = g.tickets_booking(
  order_id: order_id,
  mail_address: 'invanov@mail.ru',
  note: 'test',
  passengers: passengers,
)

# relogging again

g = Gillbus.new(driver: driver).login(password: GILLBUS_PASSWORD, locale: :ru)

# buyTickets
puts 'confirmation: ' + g.buy_tickets(order_id: order_id).ticket.confirmation.inspect

# getOrderTicket
ot = g.get_order_ticket order_id: order_id, base64: true

filename = order_id + '.pdf'
puts 'saving ' + filename
File.open filename, 'wb' do |f|
  f << ot.ticket
end
