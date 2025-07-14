class Admin::ParentalConsentController < Admin::BaseController
  def index
    @pending_users = User.where(parental_consent: false)
                        .where.not(date_of_birth: nil)
                        .where('date_of_birth > ?', 18.years.ago)
                        .order(:created_at)
    
    @approved_minors = User.where(parental_consent: true)
                          .where.not(date_of_birth: nil)
                          .where('date_of_birth > ?', 18.years.ago)
                          .order(:created_at)
  end

  def approve
    @user = User.find(params[:id])
    
    if @user.update(parental_consent: true)
      redirect_to admin_parental_consent_index_path, 
                  notice: "Parental consent approved for #{@user.email}"
    else
      redirect_to admin_parental_consent_index_path, 
                  alert: "Unable to approve consent: #{@user.errors.full_messages.join(', ')}"
    end
  end

  def revoke
    @user = User.find(params[:id])
    
    if @user.update(parental_consent: false)
      redirect_to admin_parental_consent_index_path, 
                  notice: "Parental consent revoked for #{@user.email}"
    else
      redirect_to admin_parental_consent_index_path, 
                  alert: "Unable to revoke consent: #{@user.errors.full_messages.join(', ')}"
    end
  end
end 