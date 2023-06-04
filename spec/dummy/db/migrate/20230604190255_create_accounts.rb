class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.integer :tasks_count, :integer, default: 0, null: false
      t.integer :important_tasks_count, default: 0, null: false
      t.integer :unimportant_tasks_count, default: 0, null: false
      t.timestamps
    end
  end
end
