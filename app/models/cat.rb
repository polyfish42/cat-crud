require_relative 'app_model'
require_relative 'human'
require_relative 'house'

class Cat < ModelBase
  belongs_to :owner, class_name: "Human", foreign_key: :owner_id
  has_one_through :home, :human, :house

  finalize!
end
