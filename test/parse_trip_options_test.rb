require 'test_helper'
require 'pry'

class ParseTripOptionsTest < Minitest::Test
  def test_with_only_item
    xml = <<~XML.strip
    <DATA><TRIP><OPTIONS><CRITICAL_INFO>
      <ITEM>Внимание! Ознакомьтесь со списком стран, въезд в которые ограничен в связи с коронавирусом &gt;&gt;   https://busfor.com/ru/blog/covid-19-updates</ITEM>
    </CRITICAL_INFO></OPTIONS></TRIP></DATA>
    XML

    subject = Gillbus::SearchTrips::Response.parse_string(xml).trips.first.options.critical_info

    expected_result = [
      "Внимание! Ознакомьтесь со списком стран, въезд в которые ограничен в связи с коронавирусом >> https://busfor.com/ru/blog/covid-19-updates",
    ]

    assert_equal expected_result, subject
  end

  def test_with_item_and_one_critical_inf
    xml = <<~XML.strip
    <DATA><TRIP><OPTIONS><CRITICAL_INFO>
      <ITEM>Внимание! Ознакомьтесь со списком стран, въезд в которые ограничен в связи с коронавирусом &gt;&gt;   https://busfor.com/ru/blog/covid-19-updates</ITEM>
      <CRITICAL_INF ID="16">в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.</CRITICAL_INF>
    </CRITICAL_INFO></OPTIONS></TRIP></DATA>
    XML

    subject = Gillbus::SearchTrips::Response.parse_string(xml).trips.first.options.critical_info

    expected_result = [
      "Внимание! Ознакомьтесь со списком стран, въезд в которые ограничен в связи с коронавирусом >> https://busfor.com/ru/blog/covid-19-updates",
      "в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.",
    ]

    assert_equal expected_result, subject
  end

  def test_with_one_critical_inf
    xml = <<~XML.strip
    <DATA><TRIP><OPTIONS><CRITICAL_INFO>
      <CRITICAL_INF ID="16">в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.</CRITICAL_INF>
    </CRITICAL_INFO></OPTIONS></TRIP></DATA>
    XML

    subject = Gillbus::SearchTrips::Response.parse_string(xml).trips.first.options.critical_info

    expected_result = [
      "в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.",
    ]

    assert_equal expected_result, subject
  end

  def test_with_two_critical_inf
    xml = <<~XML.strip
    <DATA><TRIP><OPTIONS><CRITICAL_INFO>
      <CRITICAL_INF ID="1">Всё будет хорошо</CRITICAL_INF>
      <CRITICAL_INF ID="16">в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.</CRITICAL_INF>
    </CRITICAL_INFO></OPTIONS></TRIP></DATA>
    XML

    subject = Gillbus::SearchTrips::Response.parse_string(xml).trips.first.options.critical_info

    expected_result = [
      "Всё будет хорошо",
      "в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.",
    ]

    assert_equal expected_result, subject
  end

  def test_with_item_and_two_critical_inf
    xml = <<~XML.strip
    <DATA><TRIP><OPTIONS><CRITICAL_INFO>
      <ITEM>Будьте внимательны, дорогие мои!</ITEM>
      <CRITICAL_INF ID="1">Всё будет хорошо</CRITICAL_INF>
      <CRITICAL_INF ID="16">в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.</CRITICAL_INF>
    </CRITICAL_INFO></OPTIONS></TRIP></DATA>
    XML

    subject = Gillbus::SearchTrips::Response.parse_string(xml).trips.first.options.critical_info

    expected_result = [
      "Будьте внимательны, дорогие мои!",
      "Всё будет хорошо",
      "в связи с дорожными условиями, возможно отклонение в расписании движения в пределах 1час30.",
    ]

    assert_equal expected_result, subject
  end
end
