class Task < ActiveRecord::Base
  include AwesomeCounterCache

  belongs_to :project, optional: true
  has_one :account, through: :project
  belongs_to :user

  awesome_counter_cache_for :account
  awesome_counter_cache_for :account, column_name: "important_tasks_count", delta_magnitude: proc { |task| task.important? ? 1 : 0 }
  awesome_counter_cache_for :account, column_name: "unimportant_tasks_count", delta_magnitude: proc { |task| task.important? ? 0 : 1 }

  awesome_counter_cache_for :user
  awesome_counter_cache_for :user, column_name: "important_tasks_count", delta_magnitude: proc { |task| task.important? ? 1 : 0 }
  awesome_counter_cache_for :user, column_name: "unimportant_tasks_count", delta_magnitude: proc { |task| task.important? ? 0 : 1 }
end
