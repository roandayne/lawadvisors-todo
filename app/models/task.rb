class Task < ApplicationRecord
  # Constant values
  STATUSES = ['incomplete', 'doing', 'complete', 'pending']

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }
  validates :position, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10**10 }

  default_scope { where(deleted_at: nil).order(position: :asc) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end
