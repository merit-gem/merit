module Merit
  module Base
    module Sash
      # Methods that are common between both the active_record and mongoid sash model
      def badges
        badge_ids.map { |id| Merit::Badge.find id }
      end

      def badge_ids
        badges_sashes.map(&:badge_id)
      end

      # Retrieve the number of points from a category
      # Category 'default' is used by default
      # Use :all to sum all points
      # @category [String] The category you want to retrieve points
      def points(category = 'default')
        if category == :all
          # Note that if category is "all", will go on the else branch
          scores.inject(0) { |sum, score| sum + score.points }
        else
          s = scores.where(category: category).first.try(:points) || 0
        end
      end

      def add_points(num_points, log = 'Manually granted', category = 'default')
        if log != 'Manually granted'
          warn '[merit] [DEPRECATION] `add_points` `log` parameter is deprecated'
        end
        point = Merit::Score::Point.new
        point.log = log
        point.num_points = num_points
        scores.where(category: category).first_or_create.score_points << point
        point
      end

      # DEPRECATED: Please use <tt>subtract_points</tt> instead.
      def substract_points(num_points, log = 'Manually granted', category = 'default')
        warn '[merit] [DEPRECATION] `substract_points` is deprecated.  Please use `subtract_points` instead.'
        subtract_points num_points, log, category
      end

      def subtract_points(num_points, log = 'Manually granted', category = 'default')
        add_points(-num_points, log, category)
      end

      private

      def create_scores
        scores << Merit::Score.create
      end
    end
  end
end
