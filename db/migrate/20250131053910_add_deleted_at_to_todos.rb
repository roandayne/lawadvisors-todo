class AddDeletedAtToTodos < ActiveRecord::Migration[7.1]
  def change
    add_column :todos, :deleted_at, :datetime
  end
end
