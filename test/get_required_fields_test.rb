require 'test_helper'
require 'pry'

class GetCountriesTest < Minitest::Test
  def get_required_fields
    response_xml = File.read('test/responses/getRequiredFields.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def get_required_fields_with_one_segment
    response_xml = File.read('test/responses/getRequiredFields.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def test_required_fields
    result = get_required_fields

    dictionary = result.dictionary
    assert_equal false, dictionary[:student_ticket]
    assert_equal false, dictionary[:isic]
    assert_equal false, dictionary[:tariff_short_name]
    assert_equal false, dictionary[:tariff_cost]
    assert_equal true, dictionary[:document_type]
    assert_equal true, dictionary[:baggage_count]
    assert_equal true, dictionary[:phone]
    assert_equal true, dictionary[:mail]
    assert_equal true, dictionary[:firstname]
    assert_equal true, dictionary[:lastname]
    assert_equal true, dictionary[:birthday]
    assert_equal true, dictionary[:passport]
    assert_equal true, dictionary[:citizenship]
    assert_equal true, dictionary[:gender]
    assert_equal true, dictionary[:visa]
    assert_equal true, dictionary[:passdate]
    assert_equal true, dictionary[:only_latin_symbols]
  end

  def test_baggage_for_with_one_segment
    result = get_required_fields_with_one_segment

    assert_equal true, result.baggage.is_buy
    assert_equal 50.5, result.baggage.baggage_tariff
  end
end
