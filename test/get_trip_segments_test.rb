require 'test_helper'

class GetTripSegmentsTest < Minitest::Test
  def get_trip_segments
    Gillbus::GetTripSegments::Response.parse_string(File.read('test/responses/getTripSegments.xml'))
  end

  def test_get_trip_segments
    points = get_trip_segments.points

    assert_equal(13, points.size)
    assert_equal('Львов', points.first.geography_name)
    assert_equal('Ж/Д вокзал Львів', points.first.name)
    assert_equal('Щецин', points.last.geography_name)
    assert_equal('Автовокзал', points.last.name)
    assert_equal(1055, points.last.distance)
  end
end
