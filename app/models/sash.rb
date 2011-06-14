class Sash < ActiveRecord::Base
  has_many :badges_sashes
  has_many :badges, :through => :badges_sashes
end
