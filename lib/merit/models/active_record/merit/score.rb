module Merit
  class Score < ActiveRecord::Base
    self.table_name = :merit_scores
    belongs_to :sash
    has_many :score_points,
             dependent: :destroy,
             class_name: 'Merit::Score::Point'

    def points
      score_points.select('COALESCE(SUM(num_points), 0) AS num_points')
                  .first
                  .num_points
    end

    class Point < ActiveRecord::Base
      belongs_to :score, class_name: 'Merit::Score'
      has_one :sash, through: :score
      has_many :activity_logs,
               class_name: 'Merit::ActivityLog',
               as: :related_change
      delegate :sash_id, to: :score
    end
  end
end
