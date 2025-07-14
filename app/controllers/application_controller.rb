class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :check_parental_consent

  # Handle Pundit authorization errors
  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  private

  def handle_not_authorized
    case params[:controller]
    when 'organizations'
      if current_user.needs_parental_consent?
        redirect_to parental_consent_pending_path, alert: 'You need parental consent to access organizations.'
      else
        redirect_to organizations_path, alert: 'You are not authorized to perform this action.'
      end
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def check_parental_consent
    return unless user_signed_in?
    return if controller_name == 'parental_consent'
    return if controller_name == 'sessions' && action_name == 'destroy'
    
    if current_user.needs_parental_consent?
      redirect_to parental_consent_pending_path
    end
  end
end
