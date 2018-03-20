require_relative 'app_model'

class Human < ModelBase
  self.table_name = 'humans'
  has_many :cats
  belongs_to :house
  finalize!
end
