class Task < ApplicationRecord
  # belongs_to :parent_task, class_name: 'Task', optional: true
  belongs_to :prev_task, class_name: 'Task', optional: true
  belongs_to :next_task, class_name: 'Task', optional: true

  # Constant values
  STATUSES = ['incomplete', 'doing', 'complete', 'pending']

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }


  # Default scope
  default_scope { where(deleted_at: nil) }

  def move_after(prev_task_id)
    return if prev_task_id == self.id

    Task.transaction do
      # Lock the task and its neighboring rows
      self.lock!
      prev_task = Task.lock.find(prev_task_id)
      next_task = prev_task.next_task

      # Unlink current task
      unlink

      # Re-link in the new position
      self.update!(prev_task: prev_task, next_task: next_task)
      prev_task.update!(next_task: self)
      next_task.update!(prev_task: self) if next_task
    end
  end

  # Soft delete
  def soft_delete
    update(deleted_at: Time.current)
  end

  private

  def unlink
    # Lock previous and next tasks to prevent concurrent updates
    prev_task.lock! if prev_task
    next_task.lock! if next_task

    prev_task.update!(next_task: next_task) if prev_task
    next_task.update!(prev_task: prev_task) if next_task
  end
end
