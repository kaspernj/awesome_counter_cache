class AwesomeCounterCache::CounterCache
  attr_reader :column_name, :delta_magnitude, :id, :model_class, :relation_name

  def initialize(column_name:, delta_magnitude:, id:, model_class:, relation_name:)
    @column_name = column_name
    @delta_magnitude = delta_magnitude
    @id = id
    @model_class = model_class
    @relation_name = relation_name

    raise "Invalid model class: #{model_class&.name}" if model_class.blank?
    raise "Invalid relation name: #{relation_name}" if relation_name.blank?
  end

  def reflection
    model_class.reflections.fetch(relation_name.to_s)
  end

  def relation_foreign_key
    reflection.foreign_key
  end
end
