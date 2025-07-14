class Admin::AnalyticsController < Admin::BaseController
  def index
    @organizations = Organization.includes(:users, :user_organizations).all
    @total_users = User.count
    @total_organizations = Organization.count
    @users_needing_consent = User.where(parental_consent: false, date_of_birth: (18.years.ago..Date.current)).count
    
    # Update analytics for all organizations
    update_all_analytics
    
    @recent_analytics = OrganizationAnalytic.includes(:organization)
                                           .order(recorded_at: :desc)
                                           .limit(20)
  end

  def organization
    @organization = Organization.find(params[:id])
    @analytics = @organization.organization_analytics.order(recorded_at: :desc)
    
    # Update analytics for this organization
    update_organization_analytics(@organization)
    
    @analytics = @organization.organization_analytics.order(recorded_at: :desc)
  end

  private

  def update_all_analytics
    Organization.find_each do |org|
      update_organization_analytics(org)
    end
  end

  def update_organization_analytics(organization)
    current_time = Time.current
    
    # Track total members
    total_members = organization.users.count
    create_or_update_analytic(organization, 'total_members', total_members, current_time)
    
    # Track members by age group
    organization.users.group(:age_group).count.each do |age_group, count|
      create_or_update_analytic(organization, "#{age_group}_members", count, current_time)
    end
    
    # Track members by role
    organization.user_organizations.group(:role).count.each do |role, count|
      create_or_update_analytic(organization, "#{role}_count", count, current_time)
    end
    
    # Track content count
    content_count = organization.contents.count
    create_or_update_analytic(organization, 'total_content', content_count, current_time)
    
    # Track content by age rating
    organization.contents.group(:age_rating).count.each do |rating, count|
      create_or_update_analytic(organization, "#{rating}_content", count, current_time)
    end
  end

  def create_or_update_analytic(organization, metric_name, value, time)
    # For simplicity, create new records each time (in production you might want to update existing ones)
    organization.organization_analytics.create!(
      metric_name: metric_name,
      metric_value: value,
      recorded_at: time
    )
  end
end 