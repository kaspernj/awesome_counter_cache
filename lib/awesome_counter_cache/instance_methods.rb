module AwesomeCounterCache::InstanceMethods
  def update_awesome_counter_cache_for(relation_name, count_relation_name, args)
    relation_model = __send__(relation_name)
    count = relation_model.__send__(count_relation_name).count
    relation_model.update_columns(args.fetch(:column_name) => count)
  end
end
