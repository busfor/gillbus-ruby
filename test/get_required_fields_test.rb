require 'test_helper'

class GetRequiredFieldsTest < Minitest::Test
  def get_required_fields_without_baggage
    response_xml = File.read('test/responses/getRequiredFieldsWithoutBaggage.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def get_required_fields_with_one_baggage
    response_xml = File.read('test/responses/getRequiredFieldsWithOneBaggage.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def get_required_fields_with_two_baggage_segments
    response_xml = File.read('test/responses/getRequiredFieldsWithTwoBaggageSegments.xml')
    Gillbus::GetRequiredFields::Response.parse_string(response_xml)
  end

  def test_required_fields_without_baggage
    result = get_required_fields_without_baggage

    assert_nil result.baggage

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

  def test_required_fields_with_one_baggage
    result = get_required_fields_with_one_baggage
    baggage = result.baggage

    assert_equal true, baggage.is_buy
    assert_equal 50.5, baggage.baggage_tariff

    assert_equal [], baggage.segments
    assert_nil baggage.segment_number
  end

  def test_required_fields_with_two_baggage_segments
    result = get_required_fields_with_two_baggage_segments
    baggage = result.baggage

    assert_nil baggage.is_buy
    assert_nil baggage.baggage_tariff
    assert_nil baggage.baggage_limit

    assert_equal 2, baggage.segments.count
    first_baggage_segment = baggage.segments[0]
    second_baggage_segment = baggage.segments[1]

    assert_equal 0, first_baggage_segment.segment_number
    assert_equal true, first_baggage_segment.is_buy
    assert_equal 70.7, first_baggage_segment.baggage_tariff
    assert_equal 2, first_baggage_segment.baggage_limit

    assert_equal 1, second_baggage_segment.segment_number
    assert_equal false, second_baggage_segment.is_buy
    assert_nil second_baggage_segment.baggage_tariff
    assert_nil second_baggage_segment.baggage_limit
  end
end
