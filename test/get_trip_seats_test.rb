require 'test_helper'

class GetTripSeatsTest < Minitest::Test

  def get_trip_seats
    Gillbus::GetTripSeats::Response.parse_string(File.read('test/responses/getTripSeats.xml'))
  end

  def get_trip_seats_with_segments
    Gillbus::GetTripSeats::Response.parse_string(File.read('test/responses/getTripSeats-segments.xml'))
  end

  def get_trip_seats_with_one_empty_segment
    Gillbus::GetTripSeats::Response.parse_string(File.read('test/responses/getTripSeats-one-empty-segment.xml'))
  end

  def test_seats
    seats = get_trip_seats.seats
    max_x = seats.map(&:x).max
    max_y = seats.map(&:y).max
    assert_equal( 70, seats.size )
    assert_equal( 4, max_y )
    assert_equal( 13, max_x )
  end

  def test_seats_with_segments
    segments = get_trip_seats_with_segments.segments
    assert_equal 2, segments.size
    assert_equal [0, 1], segments.keys
    assert_equal 70, segments.values.first.size
  end

  def test_seats_with_one_segment_without_seatmap
    segments = get_trip_seats_with_one_empty_segment.segments
    assert_equal 2, segments.size
    assert_equal [0, 1], segments.keys
    assert [], segments[0]
    assert_equal 80, segments[1].size
  end
end
