class Schedule < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validate :valid_date_range?

  scope :desc, -> {order(created_at: :desc)}

  def valid_date_range?
    return if started_at.blank? && ended_at.blank?
    errors.add(message: 'invalid date range') if started_at.blank? && ended_at.present?
    errors.add(message: 'invalid date range') if ended_at.blank? && started_at.present? 
    if ended_at < started_at || ended_at < DateTime.now || started_at < DateTime.now 
      errors.add(message: 'invalid date range')
    end
  end
end
