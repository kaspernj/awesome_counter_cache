class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :roles_count, null: false, default: 0
      t.timestamps
    end
  end
end
