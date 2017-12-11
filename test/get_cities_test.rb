require 'test_helper'

class GetCitiesTest < Minitest::Test
  def get_cities
    Gillbus::GetCities::Response.parse_string(File.read('test/responses/getCities.xml'))
  end

  def test_cities
    assert_equal( 'Афины', get_cities.cities.first.name)
  end
end
