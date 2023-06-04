class AddProjectToTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :project, foreign_key: true
  end
end
