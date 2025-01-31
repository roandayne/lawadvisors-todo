class Todo < ApplicationRecord

  # Constant values
  STATUSES = ['incomplete', 'doing', 'complete', 'pending']

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }
  validates :position, numericality: { only_integer: true }

  # Default scope
  default_scope { order(position: :asc) }
end
