require_relative 'app_model'

class House < ModelBase
  has_many :humans
  finalize!
end
