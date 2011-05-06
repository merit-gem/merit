class TalentAction < ActiveRecord::Base
  def processed!
    self.processed = true
    self.save
  end
end