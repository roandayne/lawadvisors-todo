class AddIndexToTodosPosition < ActiveRecord::Migration[7.1]
  def change
    add_index :todos, :position
  end
end
