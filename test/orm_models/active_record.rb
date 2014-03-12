require 'test_helper'

class User < ActiveRecord::Base
  has_merit
end

class Fruit < ActiveRecord::Base
end

class Soldier < ActiveRecord::Base
  has_merit
end
class Player < ActiveRecord::Base
  has_merit
end