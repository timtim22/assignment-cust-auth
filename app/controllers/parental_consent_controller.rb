class ParentalConsentController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_consent_needed, only: [:pending]

  def pending
    # Show the pending consent screen
  end

  private

  def check_if_consent_needed
    # Redirect if user doesn't need parental consent
    if current_user.has_full_access?
      redirect_to root_path, notice: "You already have full access to the application."
    end
  end
end
