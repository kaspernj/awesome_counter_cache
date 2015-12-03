module AwesomeCounterCache::ClassMethods
  def awesome_counter_cache_for(relation_name, count_relation_name, args = {})
    args[:column_name] ||= "#{count_relation_name}_count"

    after_commit do |model|
      model.update_awesome_counter_cache_for(relation_name, count_relation_name, args)
    end
  end
end
