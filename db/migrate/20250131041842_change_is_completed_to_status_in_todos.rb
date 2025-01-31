class ChangeIsCompletedToStatusInTodos < ActiveRecord::Migration[7.1]
  def change
    rename_column :todos, :is_completed, :status
    change_column :todos, :status, :string, default: 'incomplete', null: false
  end
end
