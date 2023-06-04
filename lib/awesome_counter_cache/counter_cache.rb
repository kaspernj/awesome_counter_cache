class AwesomeCounterCache::CounterCache
  attr_accessor :column_name, :delta_magnitude, :id, :relation_foreign_key, :relation_name

  def initialize(column_name:, delta_magnitude:, id:, relation_foreign_key:, relation_name:)
    @column_name = column_name
    @delta_magnitude = delta_magnitude
    @id = id
    @relation_foreign_key = relation_foreign_key
    @relation_name = relation_name
  end
end
