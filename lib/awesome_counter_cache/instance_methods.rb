module AwesomeCounterCache::InstanceMethods
  def create_awesome_counter_cache_for(relation_name, state_data, args)
    relation_model = __send__(relation_name)
    return if relation_model.blank?

    addition = state_data.fetch(:delta_current)

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, args.fetch(:column_name) => addition)
    end
  end

  def destroy_awesome_counter_cache_for(relation_name, state_data, args)
    relation_model = __send__(relation_name)
    return if relation_model.blank?

    addition = -state_data.fetch(:delta_original)

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, args.fetch(:column_name) => addition)
    end
  end

  def update_awesome_counter_cache_for(relation_name, state_data, args)
    relation_model = __send__(relation_name)
    return if relation_model.blank?

    addition = state_data.fetch(:delta_current) - state_data.fetch(:delta_original)

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, args.fetch(:column_name) => addition)
    end
  end
end
