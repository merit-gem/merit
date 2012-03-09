class Badge < ActiveRecord::Base
  has_many :badges_sashes
  has_many :sashes, :through => :badges_sashes
end
