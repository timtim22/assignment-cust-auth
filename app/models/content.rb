class Content < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10, maximum: 5000 }
  validates :age_rating, presence: true, inclusion: { in: %w[child teen adult] }
  
  # Validate user is member of organization
  validate :user_must_be_member

  # Scopes
  scope :for_age_rating, ->(rating) { where(age_rating: rating) }
  scope :for_age_group, ->(age_group) do
    case age_group
    when 'child'
      where(age_rating: 'child')
    when 'teen'
      where(age_rating: ['child', 'teen'])
    when 'adult'
      where(age_rating: ['child', 'teen', 'adult'])
    else
      none
    end
  end
  scope :recent, -> { order(created_at: :desc) }
  scope :by_organization, ->(org) { where(organization: org) }

  # Check if content is appropriate for user
  def appropriate_for_user?(user)
    return false unless user.age_group
    
    case user.age_group
    when 'child'
      age_rating == 'child'
    when 'teen'
      %w[child teen].include?(age_rating)
    when 'adult'
      %w[child teen adult].include?(age_rating)
    else
      false
    end
  end

  # Age rating helpers
  def child_content?
    age_rating == 'child'
  end

  def teen_content?
    age_rating == 'teen'
  end

  def adult_content?
    age_rating == 'adult'
  end

  # Display methods
  def age_rating_display
    case age_rating
    when 'child'
      '👶 Child (0-12)'
    when 'teen'
      '🧒 Teen (13-17)'
    when 'adult'
      '👨 Adult (18+)'
    end
  end

  def snippet(length = 100)
    body.length > length ? "#{body[0...length]}..." : body
  end

  private

  def user_must_be_member
    return unless user && organization
    
    unless organization.user_member?(user)
      errors.add(:user, "must be a member of the organization")
    end
  end
end
