require 'test_helper'

class GetRequiredFieldsTest < Minitest::Test
  def get_required_fields_without_luggage
    response_xml = File.read('test/responses/getRequiredFieldsWithoutLuggage.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def get_required_fields_with_one_luggage
    response_xml = File.read('test/responses/getRequiredFieldsWithOneLuggage.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def get_required_fields_with_two_luggage_segments
    response_xml = File.read('test/responses/getRequiredFieldsWithTwoLuggageSegments.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def test_required_fields_without_luggage
    result = get_required_fields_without_luggage

    assert_nil result.luggage

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

  def test_required_fields_with_one_luggage
    result = get_required_fields_with_one_luggage
    luggage = result.luggage

    assert_equal true, luggage.is_buy
    assert_equal 50.5, luggage.luggage_tariff

    assert_equal [], luggage.segments
    assert_nil luggage.segment_number
  end

  def test_required_fields_with_two_luggage_segments
    result = get_required_fields_with_two_luggage_segments
    luggage = result.luggage

    assert_nil luggage.is_buy
    assert_nil luggage.luggage_tariff
    assert_nil luggage.luggage_limit

    assert_equal 2, luggage.segments.count
    first_luggage_segment = luggage.segments[0]
    second_luggage_segment = luggage.segments[1]

    assert_equal 0, first_luggage_segment.segment_number
    assert_equal true, first_luggage_segment.is_buy
    assert_equal 70.7, first_luggage_segment.luggage_tariff
    assert_equal 2, first_luggage_segment.luggage_limit

    assert_equal 1, second_luggage_segment.segment_number
    assert_equal false, second_luggage_segment.is_buy
    assert_nil second_luggage_segment.luggage_tariff
    assert_nil second_luggage_segment.luggage_limit
  end
end
