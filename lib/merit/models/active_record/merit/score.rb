module Merit
  class Score < ActiveRecord::Base
    self.table_name = :merit_scores
    belongs_to :sash
    has_many :score_points, :dependent => :destroy, class_name: 'Merit::Score::Point'

    # Meant to display a leaderboard. Accepts options :table_name (users by
    # default), :since_date (1.month.ago by default) and :limit (10 by
    # default).
    #
    # It lists top 10 scored objects in the last month, unless you change
    # query parameters.
    def self.top_scored(options = {})
      options[:table_name] ||= :users
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10

      alias_id_column = "#{options[:table_name].to_s.singularize}_id"
      if options[:table_name] == :sashes
        sash_id_column = "#{options[:table_name]}.id"
      else
        sash_id_column = "#{options[:table_name]}.sash_id"
      end

      # MeritableModel – Sash –< Scores –< ScorePoints
      sql_query = <<SQL
SELECT
  #{options[:table_name]}.id AS #{alias_id_column},
  SUM(num_points) as sum_points
FROM #{options[:table_name]}
  LEFT JOIN merit_scores ON merit_scores.sash_id = #{sash_id_column}
  LEFT JOIN merit_score_points ON merit_score_points.score_id = merit_scores.id
WHERE merit_score_points.created_at > '#{options[:since_date]}'
GROUP BY merit_scores.sash_id
ORDER BY sum_points DESC
LIMIT #{options[:limit]}
SQL
      ActiveRecord::Base.connection.execute(sql_query)
    end

    def points
      score_points.group(:score_id).sum(:num_points).values.first || 0
    end

    class Point < ActiveRecord::Base
      belongs_to :score, :class_name => 'Merit::Score'
      has_many :activity_logs, class_name: Merit::ActivityLog, as: :related_change
    end
  end
end
