require "test_helper"

class ParentalConsentControllerTest < ActionDispatch::IntegrationTest
  test "should get pending" do
    get parental_consent_pending_url
    assert_response :success
  end
end
