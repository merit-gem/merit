module Merit::Models::ActiveRecord
  class BadgesSash < ActiveRecord::Base
    include Merit::Models::BadgesSashConcern

    has_many :activity_logs,
             class_name: 'Merit::ActivityLog',
             as: :related_change

    validates_presence_of :badge_id, :sash
  end
end

class Merit::BadgesSash < Merit::Models::ActiveRecord::BadgesSash; end
