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
        },
        {
          birthday: Date.parse('1990-02-02'),
          student_ticket: 'STUDENTTICKET#2',
          student_year: 2,
          isic: 'ISIC#2',
        }
      ],
    )

    expected_params = {
      startDateSearch: "04.02.2013",
      selectedModes: "3;8",
      roundTrip: "1",
      passenger0birthday: '01.01.1990',
      passenger0studentTicket: 'STUDENTTICKET#1',
      passenger0studentYear: 1,
      passenger0ISIC: 'ISIC#1',
      passenger1birthday: '02.02.1990',
      passenger1studentTicket: 'STUDENTTICKET#2',
      passenger1studentYear: 2,
      passenger1ISIC: 'ISIC#2',
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

  def test_fields_parsing
    response = get_successful_search_trips
    assert_equal Date.new(2014,8,23), response.trips.first.start_date
    assert_equal Money.new(1410_00, "RUB"), response.trips.first.total_cost
    assert_equal Money.new(1410_00, "RUB"), response.trips.first.tariffs.first.cost
  end

  def test_faking_response
    trip = Gillbus::Trip.new(
      id: '12345',
      start_date: Date.today
    )
    assert_equal '12345', trip.id
    assert_equal Date.today, trip.start_date
  end

  def test_trips_with_segments
    response = get_trips_with_segments
    assert response.completed
    assert_equal 2, response.trips.size
    assert_equal 2, response.trips.first.segments.size
  end

end
