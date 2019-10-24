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

  def get_trip_seats_with_back_seats
    Gillbus::GetTripSeats::Response.parse_string(File.read('test/responses/getTripSeats-back-seats.xml'))
  end

  def get_trip_seats_with_two_floors
    Gillbus::GetTripSeats::Response.parse_string(File.read('test/responses/getTripSeats-two-floors.xml'))
  end

  def test_seats
    seats = get_trip_seats.seats
    max_x = seats.map(&:x).max
    max_y = seats.map(&:y).max
    max_z = seats.map(&:z).max
    z_seats_count = seats.count(&:z)
    assert_equal(70, seats.size)
    assert_equal(4, max_y)
    assert_equal(13, max_x)
    assert_equal(0, max_z)
    assert_equal(seats.size, z_seats_count)
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

  def test_seats_with_back_seats
    response = get_trip_seats_with_back_seats

    assert_equal true, response.seats.count > 0
    assert_equal true, response.back_seats.count > 0

    back_seat = response.back_seats.first
    assert_equal '4925214118', back_seat.id
    assert_equal 'В1', back_seat.number
    assert_equal 2, back_seat.type
    assert_equal 0, back_seat.x
    assert_equal 0, back_seat.y
  end

  def test_seats_with_back_seats_two_floors
    seats = get_trip_seats_with_two_floors.seats
    groupped_seats_by_floor = seats.group_by(&:z)
    z0_seats_count = groupped_seats_by_floor[0]
    z1_seats_count = groupped_seats_by_floor[1]

    assert_equal true, z0_seats_count.count > 0
    assert_equal true, z1_seats_count.count > 0
  end
end
