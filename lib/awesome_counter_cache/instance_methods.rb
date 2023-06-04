module AwesomeCounterCache::InstanceMethods
  def awesome_counter_cache_after_commit_on_create(counter_cache, model)
    id = counter_cache.id
    state = @awesome_counter_cache_data.fetch(id)
    state.delta_current = counter_cache.delta_magnitude.call(model)
    model.create_awesome_counter_cache_for(@awesome_counter_cache_data.fetch(id), counter_cache)
    state.delta_original = state.delta_current
    state.delta_current = nil
  end

  def awesome_counter_cache_after_commit_on_destroy(counter_cache, model)
    id = counter_cache.id
    state = @awesome_counter_cache_data.fetch(id)
    state.delta_current = counter_cache.delta_magnitude.call(model)
    model.destroy_awesome_counter_cache_for(@awesome_counter_cache_data.fetch(id), counter_cache)
    state.delta_original = state.delta_current
    state.delta_current = nil
  end

  def awesome_counter_cache_after_commit_on_update(counter_cache, model)
    id = counter_cache.id
    state = @awesome_counter_cache_data.fetch(id)
    state.delta_current = counter_cache.delta_magnitude.call(model)
    model.update_awesome_counter_cache_for(@awesome_counter_cache_data.fetch(id), counter_cache)
    state.delta_original = state.delta_current
    state.delta_current = nil
  end

  def awesome_counter_cache_after_initialize(counter_cache, model)
    id = counter_cache.id

    @awesome_counter_cache_data ||= {}
    @awesome_counter_cache_data[id] ||= AwesomeCounterCache::State.new

    primary_key_column = self.class.primary_key

    if read_attribute(primary_key_column).nil? # `new_record?` always returns false so check if primary key is nil instead - kaspernj
      @awesome_counter_cache_data.fetch(id).delta_original ||= 0
    else
      @awesome_counter_cache_data.fetch(id).delta_original ||= counter_cache.delta_magnitude.call(model)
    end
  end

  def create_awesome_counter_cache_for(state, counter_cache)
    relation_model = __send__(counter_cache.relation_name)
    return if relation_model.blank?

    addition = state.delta_current

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, counter_cache.column_name => addition) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def reload(*args, &blk)
    result = super
    awesome_counter_cache_reset_original_values
    result
  end

  def awesome_counter_cache_reset_original_values
    self.class.awesome_counter_caches.each do |id, counter_cache|
      state = @awesome_counter_cache_data.fetch(id)
      state.delta_original = counter_cache.delta_magnitude.call(self)
    end
  end

  def destroy_awesome_counter_cache_for(state, counter_cache)
    relation_model = __send__(counter_cache.relation_name)
    return if relation_model.blank?

    addition = -state.delta_original

    if addition != 0
      primary_key_value = relation_model.read_attribute(relation_model.class.primary_key)
      relation_model.class.update_counters(primary_key_value, counter_cache.column_name => addition) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def update_awesome_counter_cache_for(state, counter_cache) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
    addition = state.delta_current - state.delta_original
    relation_model_class = counter_cache.reflection.klass

    if counter_cache.reflection.options[:through]
      # Read ID through relationship because there isn't a column to read from
      primary_key_value = __send__(counter_cache.relation_name)&.id
    else
      # Read ID directly from column because its faster (no db-lookup)
      # Use __send__ because read_attribute fails silently if column doesn't exist
      primary_key_value = __send__(counter_cache.relation_foreign_key)
    end

    if saved_changes.key?(counter_cache.relation_foreign_key)
      # Record change from one to another - reduce and increase based on previously recorded values
      old_record_id = saved_changes.fetch(counter_cache.relation_foreign_key).first

      if old_record_id && !state.delta_original.zero?
        # Reduce the count of the previous record
        relation_model_class.update_counters(old_record_id, counter_cache.column_name => -state.delta_original) # rubocop:disable Rails/SkipsModelValidations
      end

      unless state.delta_current.zero?
        # Increase the count of the new record
        relation_model_class.update_counters(primary_key_value, counter_cache.column_name => state.delta_current) # rubocop:disable Rails/SkipsModelValidations
      end
    elsif primary_key_value && !addition.zero?
      # Add to the current record
      relation_model_class.update_counters(primary_key_value, counter_cache.column_name => addition) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
