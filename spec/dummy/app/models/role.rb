class Role < ActiveRecord::Base
  include AwesomeCounterCache

  belongs_to :user
  awesome_counter_cache_for :user, :roles, count_by: :count
end
