require 'test_helper'

class Fruit < ActiveRecord::Base
end

class Soldier < ActiveRecord::Base
  has_merit
end
class Player < ActiveRecord::Base
  has_merit
end