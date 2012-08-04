class BadgesSash < ActiveRecord::Base
  belongs_to :sash

  def badge
    Badge.find(badge_id)
  end

  # To be used in the application, mark badge granting as notified to user
  def set_notified!(badge = nil, sash = nil)
    ActiveSupport::Deprecation.warn(
        "set_notified!(badge, sash) is deprecated and may be removed from future releases, use set_notified!() instead.",
        caller
    ) if badge || sash
    self.notified_user = true
    save
  end
end
