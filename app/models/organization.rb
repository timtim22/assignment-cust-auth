class Organization < ApplicationRecord
  # Associations
  has_many :user_organizations, dependent: :destroy
  has_many :users, through: :user_organizations
  has_many :members, -> { where(user_organizations: { role: 'member' }) }, through: :user_organizations, source: :user
  has_many :admins, -> { where(user_organizations: { role: 'admin' }) }, through: :user_organizations, source: :user
  has_many :contents, dependent: :destroy
  has_many :organization_analytics, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :min_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, comparison: { greater_than: :min_age, message: "must be greater than minimum age" }

  # Scopes
  scope :available_for_age, ->(age) { where('min_age <= ? AND max_age >= ?', age, age) }
  scope :available_for_age_group, ->(age_group) do
    case age_group
    when 'child'
      where('min_age <= 12 AND max_age >= 0')
    when 'teen'
      where('min_age <= 17 AND max_age >= 13')
    when 'adult'
      where('max_age >= 18')
    else
      none
    end
  end
  scope :child_friendly, -> { where('min_age <= 12') }
  scope :teen_friendly, -> { where('min_age <= 17 AND max_age >= 13') }
  scope :adult_only, -> { where('min_age >= 18') }

  # Instance methods
  def available_for_user?(user)
    return false unless user.age
    user.age >= min_age && user.age <= max_age
  end

  def user_role(user)
    user_organizations.find_by(user: user)&.role
  end

  def user_member?(user)
    user_organizations.exists?(user: user)
  end

  def user_admin?(user)
    user_organizations.exists?(user: user, role: 'admin')
  end

  # Age group classification for organizations
  def target_age_groups
    groups = []
    groups << 'child' if min_age <= 12
    groups << 'teen' if min_age <= 17 && max_age >= 13
    groups << 'adult' if max_age >= 18
    groups
  end

  def child_friendly?
    min_age <= 12
  end

  def teen_friendly?
    min_age <= 17 && max_age >= 13
  end

  def adult_only?
    min_age >= 18
  end

  def mixed_age_group?
    target_age_groups.size > 1
  end

  def primary_age_group
    if adult_only?
      'adult'
    elsif min_age <= 12 && max_age <= 12
      'child'
    elsif min_age >= 13 && max_age <= 17
      'teen'
    else
      'mixed'
    end
  end
end
