module Merit
  module Base
    module Sash
      def badges
        badge_ids.map { |id| Merit::Badge.find id }
      end

      def badge_ids
        badges_sashes.map(&:badge_id)
      end

      def add_badge(badge_id)
        bs = Merit::BadgesSash.new(badge_id: badge_id.to_i)
        badges_sashes << bs
        bs
      end

      def rm_badge(badge_id)
        badges_sashes.where(badge_id: badge_id.to_i).first.try(:destroy)
      end

      # Retrieve the number of points from a category
      # By default all points are summed up
      # @param category [String] The category
      # @return [Integer] The number of points
      def points(options = {})
        if (category = options[:category])
          scores.where(category: category).first.try(:points) || 0
        else
          scores.reduce(0) { |sum, score| sum + score.points }
        end
      end

      def add_points(num_points, options = {})
        point = Merit::Score::Point.new
        point.num_points = num_points
        scores
          .where(category: options[:category] || 'default')
          .first_or_create
          .score_points << point
        point
      end

      def subtract_points(num_points, options = {})
        add_points(-num_points, options)
      end

      private

      def create_scores
        scores << Merit::Score.create
      end
    end
  end
end
