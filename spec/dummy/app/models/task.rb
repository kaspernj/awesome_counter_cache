class Task < ActiveRecord::Base
  include AwesomeCounterCache

  belongs_to :user

  awesome_counter_cache_for :user
  awesome_counter_cache_for :user, column_name: "important_tasks_count", delta_magnitude: proc { |task| task.important? ? 1 : 0 }
  awesome_counter_cache_for :user, column_name: "unimportant_tasks_count", delta_magnitude: proc { |task| task.important? ? 0 : 1 }
end
