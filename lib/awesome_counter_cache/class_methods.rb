module AwesomeCounterCache::ClassMethods
  def awesome_counter_cache_for(relation_name, args = {})
    args[:column_name] ||= "#{model_name.plural}_count"
    args[:delta_magnitude] ||= proc { 1 }

    after_initialize do |model|
      awesome_counter_cache_after_initialize(args, model, relation_name)
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
end
