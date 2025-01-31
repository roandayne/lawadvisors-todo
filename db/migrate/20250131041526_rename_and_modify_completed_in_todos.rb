class RenameAndModifyCompletedInTodos < ActiveRecord::Migration[7.1]
  def change
    rename_column :todos, :completed, :is_completed
    change_column_default :todos, :is_completed, false
    change_column_null :todos, :is_completed, false
  end
end
