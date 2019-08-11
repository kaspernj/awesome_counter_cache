module AwesomeCounterCache::ClassMethods
  def awesome_counter_cache_for(relation_name, args = {})
    args[:column_name] ||= "#{model_name.plural}_count"
    args[:delta_magnitude] ||= proc { 1 }

    after_initialize do |model|
      @awesome_counter_cache_data ||= {}
      @awesome_counter_cache_data[relation_name] ||= {}

      primary_key_column = self.class.primary_key

      if read_attribute(primary_key_column).nil? # `new_record?` always returns false so check if primary key is nil instead - kaspernj
        @awesome_counter_cache_data.fetch(relation_name)[:delta_original] ||= 0
      else
        @awesome_counter_cache_data.fetch(relation_name)[:delta_original] ||= args.fetch(:delta_magnitude).call(model)
      end
    end

    after_commit on: :create do |model|
      @awesome_counter_cache_data.fetch(relation_name)[:delta_current] = args.fetch(:delta_magnitude).call(model)
      model.create_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(relation_name), args)
      @awesome_counter_cache_data[relation_name][:delta_original] = @awesome_counter_cache_data[relation_name].delete(:delta_current)
    end

    after_commit on: :destroy do |model|
      @awesome_counter_cache_data.fetch(relation_name)[:delta_current] = args.fetch(:delta_magnitude).call(model)
      model.destroy_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(relation_name), args)
      @awesome_counter_cache_data[relation_name][:delta_original] = @awesome_counter_cache_data[relation_name].delete(:delta_current)
    end

    after_commit on: :update do |model|
      @awesome_counter_cache_data.fetch(relation_name)[:delta_current] = args.fetch(:delta_magnitude).call(model)
      model.update_awesome_counter_cache_for(relation_name, @awesome_counter_cache_data.fetch(relation_name), args)
      @awesome_counter_cache_data[relation_name][:delta_original] = @awesome_counter_cache_data[relation_name].delete(:delta_current)
    end
  end
end
