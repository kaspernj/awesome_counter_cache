class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :account, foreign_key: true, null: false
      t.timestamps
    end
  end
end
