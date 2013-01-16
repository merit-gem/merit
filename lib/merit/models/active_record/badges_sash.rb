class BadgesSash < ActiveRecord::Base
  belongs_to :sash

  def self.last_granted(options = {})
    options[:since_date] ||= 1.month.ago
    options[:limit]      ||= 10
    where("created_at > '#{options[:since_date]}'").
      limit(options[:limit]).
      map(&:badge)
  end

  def badge
    Badge.find(badge_id)
  end

  # To be used in the application, mark badge granting as notified to user
  def set_notified!
    self.notified_user = true
    save
  end
end
