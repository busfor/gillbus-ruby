require "test_helper"

class BuyBookingTest < Minitest::Test

  def response
    Gillbus::BuyBooking::Response.parse_string(File.read('test/responses/buyBooking.xml'))
  end

  def test_request
    # TODO: Добавить тесты и имплементацию для всех данных что есть в доке
    request = Gillbus::BuyBooking::Request.new(
      payment_method: Gillbus::BuyBooking::Request::METHOD_NOCASH,
      ticket_count: 2,
      ticket_numbers: ["123456", "654321"],
      order_ids: ["53ec1fc6-e42a-42b2-b94f-1d5b47466526", "53ec1fc6-e42a-42b2-b94f-1d5b47466526"]
    )
    assert_equal({
      paymentMethod: 3,
      ticketCount: 2,
      ticketNumber0: "123456",
      ticketNumber1: "654321",
      orderId0: "53ec1fc6-e42a-42b2-b94f-1d5b47466526",
      orderId1: "53ec1fc6-e42a-42b2-b94f-1d5b47466526",
    }, request.params)
  end

  def test_response
    assert response.ticket.confirmation
    assert_equal [123456, 654321], response.ticket.position_numbers
  end

end
