module Base
  module Sash
    extend ActiveSupport::Concern
    included do

      # Methods that are common between both the active_record and mongoid sash model
      def badges
        badge_ids.map { |id| Merit::Badge.find id }
      end

      def badge_ids
        badges_sashes.map(&:badge_id)
      end

      def points(category = 'default')
        scores.where(category: category).first.points
      end

      def add_points(num_points, log = 'Manually granted', category = 'default')
        point = Merit::Score::Point.new
        point.log = log
        point.num_points = num_points
        self.scores.where(category: category).first.score_points << point
        point
      end

      # DEPRECATED: Please use <tt>subtract_points</tt> instead.
      def substract_points(num_points, log = 'Manually granted', category = 'default')
        warn "[DEPRECATION] `substract_points` is deprecated.  Please use `subtract_points` instead."
        subtract_points num_points, log, category
      end

      def subtract_points(num_points, log = 'Manually granted', category = 'default')
        add_points -num_points, log, category
      end

      private

      def create_scores
        self.scores << Merit::Score.create
      end

    end
  end
end