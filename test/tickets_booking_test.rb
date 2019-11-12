require 'test_helper'

class TicketsBookingTest < Minitest::Test
  def tickets_booking
    Gillbus::TicketsBooking::Response.parse_string(File.read('test/responses/ticketsBooking.xml'))
  end

  def test_number
    assert_equal('8472', tickets_booking.tickets.first.ticket_number)
  end

  def test_total
    assert_equal(Money.new(110_00, 'UAH'), tickets_booking.tickets.first.total_amount)
  end

  def test_params_generation_with_no_baggage
    request = Gillbus::TicketsBooking::Request.new(
      passengers: [
        { },
        { },
      ],
    )
    expected_params = {
      passenger0discountValue: '0.0',
      passenger1discountValue: '0.0',
    }
    assert_equal expected_params, request.params
  end

  def test_params_generation_with_baggage_with_one_segment
    request = Gillbus::TicketsBooking::Request.new(
      passengers: [
        {
          baggage: [1],
        },
        {
          baggage: [2],
        }
      ],
    )
    expected_params = {
      passenger0discountValue: '0.0',
      passenger0baggageCount: 1,
      passenger1discountValue: '0.0',
      passenger1baggageCount: 2,
    }
    assert_equal expected_params, request.params
  end

  def test_params_generation_with_baggage_with_two_segments
    request = Gillbus::TicketsBooking::Request.new(
      passengers: [
        {
          segments_baggage: [0, 1],
        },
        {
          segments_baggage: [1, 0],
        }
      ],
    )
    expected_params = {
      passenger0discountValue: '0.0',
      passenger0segment0baggageCount: 0,
      passenger0segment1baggageCount: 1,
      passenger1discountValue: '0.0',
      passenger1segment0baggageCount: 1,
      passenger1segment1baggageCount: 0,
    }
    assert_equal expected_params, request.params
  end
end
