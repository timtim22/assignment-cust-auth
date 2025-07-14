class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  private

  def ensure_admin
    # Simple admin check - in a real app you'd have a proper admin role system
    # For demo purposes, we'll check if user has any admin roles in organizations
    # or is the first user (for demo purposes)
    unless admin_user?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end

  def admin_user?
    # Demo logic: user is admin if they:
    # 1. Are an admin of any organization, OR  
    # 2. Are the first user created (for demo purposes)
    current_user&.administered_organizations&.any? || current_user&.id == 1
  end
end 