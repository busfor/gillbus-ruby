require 'test_helper'

class SearchNearbyTripsRequestTest < Minitest::Test
  def get_trips_with_nearby_cities
    Gillbus::SearchTripNearbyCities::Response.parse_string(File.read('test/responses/searchTripsNearby.xml'))
  end

  def test_trips_with_nearby_cities
    response = get_trips_with_nearby_cities
    assert response.completed
    trip = response.trips.first
    assert_equal 'Москва', trip.start_city_name
    assert_equal 'Ярославль', trip.end_city_name
    assert_equal '465.5 RUB'.to_money, trip.total_cost
    assert_equal '"ОднаКасса" ООО', trip.carrier_name
    assert_equal '09:00', trip.start_time
  end
end
