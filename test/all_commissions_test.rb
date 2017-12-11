require 'test_helper'

class AllCommissionsTest < Minitest::Test
  def response
    Gillbus::FindOrder::Response.parse_string(File.read('test/responses/ticketsBookingAllCommissions.xml'))
  end

  def test_all_commissions
    assert response.tickets.first.all_commissions
  end

  def test_in_out_value
    assert_equal "3", response.tickets.first.all_commissions.first.in_out_type
  end
end
