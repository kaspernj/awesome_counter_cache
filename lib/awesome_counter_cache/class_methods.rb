module AwesomeCounterCache::ClassMethods
  def awesome_counter_cache_for(relation_name, args = {})
    id = awesome_counter_caches.length
    args[:column_name] ||= "#{model_name.plural}_count"
    args[:delta_magnitude] ||= proc { 1 }
    args[:relation_foreign_key] = reflections.fetch(relation_name.to_s).foreign_key
    args[:relation_name] = relation_name
    args[:id] = id

    counter_cache = AwesomeCounterCache::CounterCache.new(**args)
    awesome_counter_caches[id] = counter_cache
    awesome_counter_cache_init_callbacks(counter_cache)
  end

  def awesome_counter_cache_init_callbacks(counter_cache)
    after_initialize do |model|
      awesome_counter_cache_after_initialize(counter_cache, model)
    end

    after_commit on: :create do |model|
      awesome_counter_cache_after_commit_on_create(counter_cache, model)
    end

    after_commit on: :destroy do |model|
      awesome_counter_cache_after_commit_on_destroy(counter_cache, model)
    end

    after_commit on: :update do |model|
      awesome_counter_cache_after_commit_on_update(counter_cache, model)
    end
  end

  def awesome_counter_caches
    @awesome_counter_caches ||= {}
  end
end
