require 'test_helper'

class GetTimeTableTest < Minitest::Test

  def get_time_table
    Gillbus::GetTimeTable::Response.parse_string(File.read('test/responses/getTimeTable.xml'))
  end

  def test_response
    first_trip, second_trip = get_time_table.trips

    assert first_trip.segments.size > 0
    # assert_equal [1, 6], first_trip.days_of_week
    assert_equal [:sunday, :friday], first_trip.days_of_week

    # { :monday => 0, :tuesday => 1, :wednesday => 2, :thursday => 3, :friday => 4, :saturday => 5, :sunday => 6 }

    assert second_trip.dates.size > 0
    assert Date, second_trip.dates.first.class
  end
end
