require 'test_helper'

class LockSeatsRequestTest < Minitest::Test
  def test_lock_params
    request = Gillbus::LockSeats::Request.new(
      trip_id: '2457369573939592570',
    )
    assert_equal(
      { tripId: '2457369573939592570' },
      request.params,
    )
  end

  def test_lock_params_with_seats
    request = Gillbus::LockSeats::Request.new(
      trip_id: '2457369573939592570',
      seat_ids: ['12', '13'],
    )
    assert_equal(
      {
        tripId: '2457369573939592570',
        seatId0: '12',
        seatId1: '13',
      },
      request.params,
    )
  end

  def test_lock_params_with_back_seats
    request = Gillbus::LockSeats::Request.new(
      trip_id: '2457369573939592570',
      seat_ids: ['12', '13'],
      back_seat_ids: ['14', '15'],
    )
    assert_equal(
      {
        tripId: '2457369573939592570',
        seatId0: '12',
        seatId1: '13',
        backSeatId0: '14',
        backSeatId1: '15',
      },
      request.params,
    )
  end

  def test_lock_params_with_segments_seats
    request = Gillbus::LockSeats::Request.new(
      trip_id: '2457369573939592570',
      segments_seat_ids: {
        0 => ['12', '13'],
        1 => ['14', '15'],
      },
    )
    assert_equal(
      {
        tripId: '2457369573939592570',
        segment0seatId0: '12',
        segment0seatId1: '13',
        segment1seatId0: '14',
        segment1seatId1: '15',
      },
      request.params,
    )
  end
end

class LockSeatsResponseTest < Minitest::Test
  def lock_seats
    Gillbus::LockSeats::Response.parse_string(File.read('test/responses/lockSeats.xml'))
  end

  def test_lock_seats
    assert_equal(899, lock_seats.time_limit)
  end

  def test_dictionary
    assert_equal true, lock_seats.dictionary[:mail]
  end
end
