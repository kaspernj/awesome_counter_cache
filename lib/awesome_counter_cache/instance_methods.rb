module AwesomeCounterCache::InstanceMethods
  def awesome_counter_cache_after_commit_on_create(args, model, relation_name)
    id = args.fetch(:id)
    @awesome_counter_cache_data.fetch(id)[:delta_current] = args.fetch(:delta_magnitude).call(model)
    model.create_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(id), args)
    @awesome_counter_cache_data[id][:delta_original] = @awesome_counter_cache_data[id].delete(:delta_current)
  end

  def awesome_counter_cache_after_commit_on_destroy(args, model, relation_name)
    id = args.fetch(:id)
    @awesome_counter_cache_data.fetch(id)[:delta_current] = args.fetch(:delta_magnitude).call(model)
    model.destroy_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(id), args)
    @awesome_counter_cache_data[id][:delta_original] = @awesome_counter_cache_data[id].delete(:delta_current)
  end

  def awesome_counter_cache_after_commit_on_update(args, model, relation_name)
    id = args.fetch(:id)
    @awesome_counter_cache_data.fetch(id)[:delta_current] = args.fetch(:delta_magnitude).call(model)
    model.update_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(id), args)
    @awesome_counter_cache_data[id][:delta_original] = @awesome_counter_cache_data[id].delete(:delta_current)
  end

  def awesome_counter_cache_after_initialize(args, model)
    id = args.fetch(:id)

    @awesome_counter_cache_data ||= {}
    @awesome_counter_cache_data[id] ||= {}

    primary_key_column = self.class.primary_key

    if read_attribute(primary_key_column).nil? # `new_record?` always returns false so check if primary key is nil instead - kaspernj
      @awesome_counter_cache_data.fetch(id)[:delta_original] ||= 0
    else
      @awesome_counter_cache_data.fetch(id)[:delta_original] ||= args.fetch(:delta_magnitude).call(model)
    end
  end

  def create_awesome_counter_cache_for(relation_name, state_data, args)
    relation_model = __send__(relation_name)
    return if relation_model.blank?

    addition = state_data.fetch(:delta_current)

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, args.fetch(:column_name) => addition)
    end
  end

  def reload(*args, &blk)
    super
    awesome_counter_cache_reset_original_values
  end

  def awesome_counter_cache_reset_original_values
    self.class.awesome_counter_caches.each do |id, args|
      @awesome_counter_cache_data.fetch(id)[:delta_original] = args.fetch(:delta_magnitude).call(self)
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
