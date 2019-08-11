class AddTaskCountsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tasks_count, :integer, default: 0, null: false
    add_column :users, :important_tasks_count, :integer, default: 0, null: false
    add_column :users, :unimportant_tasks_count, :integer, default: 0, null: false
  end
end
