require "test_helper"

class BuyTicketsTest < Minitest::Test

  def buy_tickets
    Gillbus::BuyTickets::Response.parse_string(File.read('test/responses/buyTickets.xml'))
  end

  def test_buy_tickets
    assert buy_tickets.ticket.confirmation
  end
end
