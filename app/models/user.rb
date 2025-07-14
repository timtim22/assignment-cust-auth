class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Organization associations
  has_many :user_organizations, dependent: :destroy
  has_many :organizations, through: :user_organizations
  has_many :administered_organizations, -> { where(user_organizations: { role: 'admin' }) }, 
           through: :user_organizations, source: :organization

  # Content associations
  has_many :contents, dependent: :destroy

  # Age verification
  validates :date_of_birth, presence: true
  validates :date_of_birth, comparison: { 
    less_than: Date.current, 
    message: "must be in the past" 
  }
  validates :date_of_birth, comparison: { 
    greater_than: 120.years.ago, 
    message: "must be a reasonable date" 
  }

  # Set parental consent and age group based on age
  before_save :set_parental_consent_for_minors
  before_save :set_age_group

  # Age calculation
  def age
    return nil unless date_of_birth
    
    today = Date.current
    age = today.year - date_of_birth.year
    age -= 1 if today < date_of_birth + age.years
    age
  end

  def minor?
    age && age < 18
  end

  def needs_parental_consent?
    minor? && !parental_consent?
  end

  def has_full_access?
    !minor? || parental_consent?
  end

  # Age group classification
  def calculate_age_group
    return 'adult' unless age
    
    case age
    when 0..12
      'child'
    when 13..17
      'teen'
    else
      'adult'
    end
  end

  # Check if user is in specific age group
  def child?
    age_group == 'child'
  end

  def teen?
    age_group == 'teen'
  end

  def adult?
    age_group == 'adult'
  end

  private

  def set_parental_consent_for_minors
    # Only set parental consent on new records or when date_of_birth changes
    # This prevents overriding admin-approved consent
    if new_record? || date_of_birth_changed?
      if minor?
        self.parental_consent = false
      else
        self.parental_consent = true
      end
    end
  end

  def set_age_group
    self.age_group = calculate_age_group
  end
end
