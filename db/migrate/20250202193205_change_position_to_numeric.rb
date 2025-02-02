class ChangePositionToNumeric < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :position, :decimal, precision: 20, scale: 10, null: false
    remove_index :tasks, :position
    add_index :tasks, :position, unique: true
  end
end
