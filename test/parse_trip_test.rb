require 'test_helper'

class ParseTripYAML < Minitest::Test
  def test_content_1
    response = Gillbus::Trip.parse(YAML.load(File.read('test/responses/legacy_trip.yml')))
    expected_causes = [
      'Без потерь,  более чем за 2 ч., до отправления рейса. Возвращается 100% стоимости тарифа. Ориентировочная сумма возврата 550',
      'Добровольно,  менее чем за 2 ч., до отправления рейса. Удерживается при возврате: 15% тарифа. Ориентировочная сумма возврата 425',
     'Возврат маршрутной квитанции в случае опоздания к отправлению (стоимость не возвращается). Удерживается при возврате: 100% тарифа. Ориентировочная сумма возврата 0',
     'Возврат маршрутной квитанции по отмене отправления т/с, задержки отправления т/с более чем на час и непредставления пассажиру указанного в билете места. СРОК ОБРАЩЕНИЯ для возврата билета 24 часа с времени отправления. . Возвращается 100% стоимости билета. Ориентировочная сумма возврата 550'
    ]

    assert_equal true, response.tariffs.first.return_cause.first.lossless
    assert_equal expected_causes, response.tariffs.first.return_cause.map(&:cause)
  end

  def test_content_2
    response = Gillbus::Trip.parse(YAML.load(File.read('test/responses/legacy_trip_2.yml')))
    assert_equal ["Принудительно, при отмене рейса. Ориентировочная сумма возврата 1044.95RUB",
 "Добровільно ДБ 4, менш ніж за 10 хвилин до відправлення рейсу. Ориентировочная сумма возврата 574.72RUB",
 "ДБ 3, не менш ніж за 10 хвилин до відправлення рейсу. Ориентировочная сумма возврата 679.21RUB",
 "Добровольно,  более чем за 2 ч., до отправления рейса. Ориентировочная сумма возврата 783.71RUB",
 "не менше ніж за 24 години до відправлення рейсу. Ориентировочная сумма возврата 888.2RUB"], response.tariffs.first.return_cause.map(&:cause)
  end
end
