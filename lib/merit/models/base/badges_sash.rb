module Merit
  module Base
    module BadgesSash
      extend ActiveSupport::Concern

      included do
        belongs_to :sash
      end

      def badge
        Merit::Badge.find(badge_id)
      end
    end
  end
end
