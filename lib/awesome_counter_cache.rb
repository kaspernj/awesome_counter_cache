module AwesomeCounterCache
  extend ActiveSupport::Autoload

  autoload :ClassMethods
  autoload :InstanceMethods

  def self.included(base)
    base.extend AwesomeCounterCache::ClassMethods
    base.include AwesomeCounterCache::InstanceMethods
  end
end
