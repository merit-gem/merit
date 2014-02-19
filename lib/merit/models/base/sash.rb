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
      # By default all points are summed up
      # @param category [String] The category
      # @return [Integer] The number of points
      def points(options={})
        if (category = options[:category])
          scores.where(category: category).first.try(:points) || 0
        else
          scores.inject(0) { |sum, score| sum + score.points }
        end
      end

      def add_points(num_points, category = 'default')
        point = Merit::Score::Point.new
        point.num_points = num_points
        scores.where(category: category).first_or_create.score_points << point
        point
      end

      def subtract_points(num_points, category = 'default')
        add_points(-num_points, category)
      end

      private

      def create_scores
        scores << Merit::Score.create
      end
    end
  end
end
