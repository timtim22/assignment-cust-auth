class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  # Validations
  validates :role, presence: true, inclusion: { in: %w[member admin] }
  validates :user_id, uniqueness: { scope: :organization_id, message: "is already a member of this organization" }
  
  # Validate user meets age requirements
  validate :user_meets_age_requirements

  # Scopes
  scope :members, -> { where(role: 'member') }
  scope :admins, -> { where(role: 'admin') }

  private

  def user_meets_age_requirements
    return unless user && organization
    
    unless organization.available_for_user?(user)
      errors.add(:base, "User age (#{user.age}) does not meet organization requirements (#{organization.min_age}-#{organization.max_age})")
    end
  end
end
