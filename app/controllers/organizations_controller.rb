class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :join, :leave]

  def index
    authorize Organization
    @organizations = policy_scope(Organization)
    @available_organizations = current_user.age ? Organization.available_for_age(current_user.age) : []
    @user_organizations = current_user.organizations
  end

  def show
    authorize @organization
    @user_membership = current_user.user_organizations.find_by(organization: @organization)
    @is_member = @user_membership.present?
    @user_role = @user_membership&.role
    @can_join = policy(@organization).join?
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    
    if @organization.save
      # Make the creator an admin of the organization
      current_user.user_organizations.create!(organization: @organization, role: 'admin')
      redirect_to @organization, notice: 'Organization was successfully created. You are now an admin.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    authorize @organization, :join?
    
    if current_user.organizations.include?(@organization)
      redirect_to @organization, alert: 'You are already a member of this organization.'
      return
    end

    @membership = current_user.user_organizations.build(organization: @organization, role: 'member')
    
    if @membership.save
      redirect_to @organization, notice: 'Successfully joined the organization!'
    else
      redirect_to @organization, alert: 'Unable to join organization: ' + @membership.errors.full_messages.join(', ')
    end
  end

  def leave
    authorize @organization, :leave?
    
    @membership = current_user.user_organizations.find_by(organization: @organization)
    
    if @membership
      @membership.destroy
      redirect_to organizations_path, notice: 'You have left the organization.'
    else
      redirect_to @organization, alert: 'You are not a member of this organization.'
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :min_age, :max_age)
  end
end
