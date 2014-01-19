module Base
  module BadgesSash
    extend ActiveSupport::Concern

    # Methods that are common between both the active_record and mongoid badges_sash model
    included do

      belongs_to :sash

      def badge
        Badge.find(badge_id)
      end

    end

  end
end