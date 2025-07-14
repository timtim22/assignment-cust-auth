class OrganizationAnalytic < ApplicationRecord
  belongs_to :organization

  # Validations
  validates :metric_name, presence: true
  validates :metric_value, presence: true, numericality: true
  validates :recorded_at, presence: true

  # Scopes
  scope :recent, -> { order(recorded_at: :desc) }
  scope :for_metric, ->(metric) { where(metric_name: metric) }
  scope :recorded_after, ->(date) { where('recorded_at >= ?', date) }
  scope :recorded_before, ->(date) { where('recorded_at <= ?', date) }

  # Helper methods
  def metric_display_name
    case metric_name
    when 'total_members'
      'Total Members'
    when 'child_members'
      'Child Members (0-12)'
    when 'teen_members'
      'Teen Members (13-17)'
    when 'adult_members'
      'Adult Members (18+)'
    when 'admin_count'
      'Administrators'
    when 'member_count'
      'Regular Members'
    when 'total_content'
      'Total Content'
    when 'child_content'
      'Child Content'
    when 'teen_content'
      'Teen Content'
    when 'adult_content'
      'Adult Content'
    else
      metric_name.humanize
    end
  end

  def formatted_value
    case metric_name
    when /count|members|content/
      metric_value.to_i
    else
      metric_value
    end
  end
end
