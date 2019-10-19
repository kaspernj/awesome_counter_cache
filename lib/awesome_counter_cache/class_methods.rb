module AwesomeCounterCache::ClassMethods
  def awesome_counter_cache_for(relation_name, args = {})
    id = awesome_counter_caches.length

    args[:column_name] ||= "#{model_name.plural}_count"
    args[:delta_magnitude] ||= proc { 1 }
    args[:relation_name] = relation_name
    args[:id] = id

    awesome_counter_caches[id] = args

    after_initialize do |model|
      awesome_counter_cache_after_initialize(args, model)
    end

    after_commit on: :create do |model|
      awesome_counter_cache_after_commit_on_create(args, model, relation_name)
    end

    after_commit on: :destroy do |model|
      awesome_counter_cache_after_commit_on_destroy(args, model, relation_name)
    end

    after_commit on: :update do |model|
      awesome_counter_cache_after_commit_on_update(args, model, relation_name)
    end
  end

  def awesome_counter_caches
    @awesome_counter_caches ||= {}
  end
end
