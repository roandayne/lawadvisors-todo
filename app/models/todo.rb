class Todo < ApplicationRecord

  # Constant values
  STATUSES = ['incomplete', 'doing', 'complete', 'pending']

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }
  validates :position, numericality: { only_integer: true }

  # Default scope
  default_scope { where(deleted_at: nil).order(position: :asc) }

   # Soft delete
  def soft_delete
    update(deleted_at: Time.current)
  end
end
