class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true, null: false
      t.boolean :important, default: false, null: false
      t.timestamps
    end
  end
end
