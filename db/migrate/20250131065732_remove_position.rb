class RemovePosition < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :position

    add_column :tasks, :next_task_id, :integer, null: true
    add_column :tasks, :prev_task_id, :integer, null: true

    add_index :tasks, :next_task_id
    add_index :tasks, :prev_task_id

    add_foreign_key :tasks, :tasks, column: :next_task_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :tasks, :tasks, column: :prev_task_id, primary_key: :id, on_delete: :cascade
  end
end
