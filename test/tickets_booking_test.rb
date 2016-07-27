require 'test_helper'

class TicketsBookingTest < Minitest::Test

  def tickets_booking
    Gillbus::TicketsBooking::Response.parse_string(File.read('test/responses/ticketsBooking.xml'))
  end

  def test_number
    assert_equal("8472", tickets_booking.tickets.first.ticket_number)
  end

  def test_total
    assert_equal(Money.new(110_00, "UAH"), tickets_booking.tickets.first.total_amount)
  end
end
