require 'test_helper'

class Fruit
  include Mongoid::Document
end

class Soldier
  include Mongoid::Document
  has_merit
end

class Player
  include Mongoid::Document
  has_merit
end