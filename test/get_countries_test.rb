require 'test_helper'

class GetCountriesTest < Minitest::Test

  def get_countries
    Gillbus::GetCountries::Response.parse_string(File.read('test/responses/getCountries.xml'))
  end

  def test_countries
    assert_equal( "Австрия", get_countries.countries.first.name)
  end
end
