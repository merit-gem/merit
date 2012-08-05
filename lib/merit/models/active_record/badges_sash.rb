class BadgesSash < ActiveRecord::Base
  belongs_to :sash

  def badge
    Badge.find(badge_id)
  end

  # To be used in the application, mark badge granting as notified to user
  def set_notified!
    self.notified_user = true
    save
  end
end
