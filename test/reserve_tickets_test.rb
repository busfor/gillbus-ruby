require 'test_helper'
require 'pry'

class ReserveTicketsTest < Minitest::Test
  def reserve_tickets(timezone: nil)
    Gillbus::ReserveTickets::Response.parse_string(
      File.read('test/responses/reserveTickets.xml'),
      timezone: timezone,
    )
  end

  def test_number
    assert_equal('8472', reserve_tickets.tickets.first.ticket_number)
  end

  def test_total
    assert_equal(Money.new(110_00, 'UAH'), reserve_tickets.tickets.first.total_amount)
  end

  def test_date_to_pay
    assert_equal(DateTime.new(2013, 5, 22, 20, 30, 0, '+3'), reserve_tickets.tickets.first.date_to_pay)
  end

  def test_date_to_pay_with_timezone
    tickets = reserve_tickets(timezone: 'Europe/Moscow')

    assert_equal(DateTime.new(2013, 5, 22, 20, 30, 0, '+4'), tickets.tickets.first.date_to_pay)
    assert_equal('MSK', tickets.tickets.first.date_to_pay.zone)
  end

  def test_working_without_options
    xml = YAML.load(File.read('test/responses/reserveTickets.yml'))
    Gillbus::ReserveTickets::Response.parse(xml) # should not raise error
  end

  def test_start_at_end_at_parsing
    # default timezone - Europe/Kiev
    response = reserve_tickets
    ticket = response.tickets.first

    # default timezone
    expected_start_at = ActiveSupport::TimeZone['Europe/Kiev'].parse('20.02.2013 14:40')
    # timezone from response
    expected_end_at = ActiveSupport::TimeZone['Europe/Prague'].parse('21.02.2013 06:35')

    assert_equal expected_start_at, ticket.start_at
    assert_equal expected_end_at, ticket.end_at
  end

  def test_start_at_end_at_parsing_with_default_timezone
    # default timezone - Europe/Moscow
    response = reserve_tickets(timezone: 'Europe/Moscow')
    ticket = response.tickets.first

    # default timezone
    expected_start_at = ActiveSupport::TimeZone['Europe/Moscow'].parse('20.02.2013 14:40')
    # timezone from response
    expected_end_at = ActiveSupport::TimeZone['Europe/Prague'].parse('21.02.2013 06:35')

    assert_equal expected_start_at, ticket.start_at
    assert_equal expected_end_at, ticket.end_at
  end
end
