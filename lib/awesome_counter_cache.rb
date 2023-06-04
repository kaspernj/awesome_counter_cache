module AwesomeCounterCache
  extend ActiveSupport::Autoload

  autoload :ClassMethods
  autoload :CounterCache
  autoload :InstanceMethods
  autoload :State

  def self.included(base)
    base.extend AwesomeCounterCache::ClassMethods
    base.include AwesomeCounterCache::InstanceMethods
  end
end
