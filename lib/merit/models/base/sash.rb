module Merit
  module Base
    module Sash
      def badges
        badge_ids.map { |id| Merit::Badge.find id }
      end

      def badge_ids
        badges_sashes.map(&:badge_id)
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

      # Retrieve all points from a category or none if category doesn't exist
      # By default retrieve all Points
      # @param category [String] The category
      # @return [ActiveRecord::Relation] containing the points
      def score_points(options = {})
        scope = Merit::Score::Point
                  .includes(:score)
                  .where('merit_scores.sash_id = ?', id)
        if (category = options[:category])
          scope = scope.where('merit_scores.category = ?', category)
        end
        scope
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
