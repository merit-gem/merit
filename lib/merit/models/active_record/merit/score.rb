module Merit
  class Score < ActiveRecord::Base
    self.table_name = :merit_scores
    belongs_to :sash
    has_many :score_points,
             dependent: :destroy,
             class_name: 'Merit::Score::Point'

    # DEPRECATED: `top_scored` will be removed from merit, please refer to:
    # https://github.com/tute/merit/wiki/How-to-show-a-points-leaderboard
    def self.top_scored(options = {})
      warn '[DEPRECATION] `top_scored` will be removed from merit, please refer to: https://github.com/tute/merit/wiki/How-to-show-a-points-leaderboard'
      options[:table_name] ||= :users
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10

      alias_id_column = "#{options[:table_name].to_s.singularize}_id"
      if options[:table_name] == :sashes
        sash_id_column = "#{options[:table_name]}.id"
      else
        sash_id_column = "#{options[:table_name]}.sash_id"
      end

      # MeritableModel - Sash -< Scores -< ScorePoints
      sql_query = <<SQL
SELECT
  #{options[:table_name]}.id AS #{alias_id_column},
  SUM(num_points) as sum_points
FROM #{options[:table_name]}
  LEFT JOIN merit_scores ON merit_scores.sash_id = #{sash_id_column}
  LEFT JOIN merit_score_points ON merit_score_points.score_id = merit_scores.id
WHERE merit_score_points.created_at > '#{options[:since_date]}'
GROUP BY #{options[:table_name]}.id, merit_scores.sash_id
ORDER BY sum_points DESC
LIMIT #{options[:limit]}
SQL
      results = ActiveRecord::Base.connection.execute(sql_query)
      results.map do |h|
        h.keep_if { |k, v| (k == alias_id_column) || (k == 'sum_points') }
      end
      results
    end

    def points
      score_points.group(:score_id).sum(:num_points).values.first || 0
    end

    class Point < ActiveRecord::Base
      belongs_to :score, class_name: 'Merit::Score'
      has_one :sash, through: :score
      has_many :activity_logs,
               class_name: Merit::ActivityLog,
               as: :related_change
    end
  end
end
