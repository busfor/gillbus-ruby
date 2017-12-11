require 'test_helper'

class SearchTripsRequestTest < Minitest::Test
  def test_params
    req = Gillbus::SearchTrips::Request.new(
      start_date_search: Date.new(2013, 2, 4),
      selected_modes: [:avia, :connections],
      round_trip: true,
      passengers: [
        {
          birthday: Date.parse('1990-01-01'),
          student_ticket: 'STUDENTTICKET#1',
          student_year: 1,
          isic: 'ISIC#1',
          with_seat: true,
        },
        {
          birthday: Date.parse('1990-02-02'),
          student_ticket: 'STUDENTTICKET#2',
          student_year: 2,
          isic: 'ISIC#2',
          with_seat: false,
        },
      ],
    )

    expected_params = {
      startDateSearch: '04.02.2013',
      selectedModes: '3;8',
      roundTrip: '1',
      passenger0birthday: '01.01.1990',
      passenger0studentTicket: 'STUDENTTICKET#1',
      passenger0studentYear: 1,
      passenger0ISIC: 'ISIC#1',
      passenger0withSeat: '1',
      passenger1birthday: '02.02.1990',
      passenger1studentTicket: 'STUDENTTICKET#2',
      passenger1studentYear: 2,
      passenger1ISIC: 'ISIC#2',
      passenger1withSeat: '0',
    }

    assert_equal expected_params, req.params
  end
end

class SearchTripsResponseTest < Minitest::Test
  def get_empty_search_trips
    Gillbus::SearchTrips::Response.parse_string(File.read('test/responses/searchTrips-empty.xml'))
  end

  def get_successful_search_trips
    Gillbus::SearchTrips::Response.parse_string(File.read('test/responses/searchTrips-prod.xml'))
  end

  def get_successful_search_trips_with_bad_data
    Gillbus::SearchTrips::Response.parse_string(File.read('test/responses/searchTrips-prod-invalid.xml'))
  end

  def get_trips_with_segments
    Gillbus::SearchTrips::Response.parse_string(File.read('test/responses/searchTrips-segments.xml'))
  end

  def test_empty_completed
    response = get_empty_search_trips
    assert response.completed
    assert_equal [], response.trips
  end

  def test_trips
    response = get_successful_search_trips
    assert response.completed
    assert_equal 2, response.trips.size
  end

  def test_custom_status
    response = get_successful_search_trips
    assert_equal 0, response.trips.first.custom_status
  end

  def test_fields_parsing
    response = get_successful_search_trips
    assert_equal Date.new(2014,8,23), response.trips.first.start_date
    assert_equal Money.new(1410_00, 'RUB'), response.trips.first.total_cost
    assert_equal Money.new(1410_00, 'RUB'), response.trips.first.tariffs.first.cost
    assert_equal 'Europe/Moscow', response.trips.first.start_timezone
    assert_equal 'Europe/Moscow', response.trips.first.end_timezone
    assert_equal true, response.trips.first.fake_time_in_road
    assert_equal false, response.trips[1].recommended
    assert_equal true, response.trips.first.recommended
    assert_equal ['cause 1', 'cause 2', 'cause 3'], response.trips.first.tariffs.first.return_cause.map(&:cause)
    assert_equal [true, false, false], response.trips.first.tariffs.first.return_cause.map(&:lossless)
    assert_equal ['cause 1'], response.trips[1].tariffs.first.return_cause.map(&:cause)
    assert_equal true, response.trips[1].tariffs.first.is_exclusive_price
    assert_equal 'http://example.com/123', response.trips.first.redirect_url
  end

  def test_start_at_parsing
    response = get_successful_search_trips

    trip1_start_at = ActiveSupport::TimeZone['Europe/Moscow'].parse('23.08.2014 19:00')
    trip2_start_at = ActiveSupport::TimeZone['Europe/Kiev'].parse('23.08.2014 21:10')

    assert_equal trip1_start_at, response.trips[0].start_at
    assert_equal trip2_start_at, response.trips[1].start_at
  end

  def test_options_parsing
    response = get_successful_search_trips
    options = response.trips.first.options

    services = {
      1 => 'Кофе',
      15 => 'Wi-Fi',
    }
    luggage_options = [
      'В стоимость входит провоз 2 единиц багажа свыше 80 кг.',
      'Ручная кладь 20см x 40см x 30см входит в стоимость билета.',
      'Превышение по багажу оплачивается в размере 1% от стоимости тарифа.',
    ]
    seating_options = [
      'Свободная рассадка.',
    ]
    technical_stops = [
      'Технические остановки осуществляются каждые 2-3 часа.',
    ]
    critical_info = [
      'ВНИМАНИЕ: Особые условия паспортного режима пересечения пропускного пункта (только с паспортами РБ и РФ).',
    ]
    resource_options = [
      'Посадка начинается за 10 мин.',
    ]
    other_options = [
      'Переправа',
      'Трансфер',
      'Cкидка при покупке раунд-трипа',
    ]

    assert_equal services.values, options.services.map(&:name)
    assert_equal services.keys, options.services.map(&:id)
    assert_equal luggage_options, options.luggage
    assert_equal seating_options, options.seating
    assert_equal technical_stops, options.technical_stops
    assert_equal critical_info, options.critical_info
    assert_equal resource_options, options.resource_options
    assert_equal other_options, options.other
    assert options.advertising
    assert options.busfor_recommend
  end

  def test_empty_options_parsing
    response = get_successful_search_trips
    options = response.trips.last.options

    assert_equal [], options.services
    assert_equal [], options.luggage
    assert_equal [], options.seating
    assert_equal [], options.technical_stops
    assert_equal [], options.critical_info
    assert_equal [], options.resource_options
    assert_equal [], options.other
  end

  def test_fields_parsing_bad_data
    response = get_successful_search_trips_with_bad_data
    assert response.error?
    assert_includes response.response.to_s, '23/08/2014'
  end

  def test_faking_response
    trip = Gillbus::Trip.new(
      id: '12345',
      start_date: Date.today,
    )
    assert_equal '12345', trip.id
    assert_equal Date.today, trip.start_date
  end

  def test_trips_with_segments
    response = get_trips_with_segments
    assert response.completed
    assert_equal 2, response.trips.size
    assert_equal 'Europe/Kiev', response.trips.first.start_timezone
    assert_equal 'Europe/Kiev', response.trips.first.end_timezone
    assert_equal true, response.trips.first.fake_time_in_road
    assert_equal 2, response.trips.first.segments.size
  end
end
