module Merit
  class BadgesSash < ActiveRecord::Base
    include Base::BadgesSash

    has_many :activity_logs,
             class_name: 'Merit::ActivityLog',
             as: :related_change

    validates_presence_of :badge_id, :sash
  end
end
