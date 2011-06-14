class Badge < ActiveRecord::Base
  has_many :badges_sashes
  has_many :sashes, :through => :badges_sashes

  def grant_to(sash)
    unless sash.badges.include? self
      sash.badges << self
      sash.save
    end
  end
end