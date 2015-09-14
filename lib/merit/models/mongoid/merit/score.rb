module Merit
  class Score
    include Mongoid::Document
    include Mongoid::Timestamps

    field :category, type: String, default: 'default'

    belongs_to :sash, class_name: 'Merit::Sash'
    has_many :score_points, class_name: 'Merit::Score::Point', dependent: :destroy

    # Meant to display a leaderboard. Accepts options :table_name (users by
    # default), :since_date (1.month.ago by default) and :limit (10 by
    # default).
    #
    # It lists top 10 scored objects in the last month, unless you change
    # query parameters.
    def self.top_scored(options = {})
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      Score.where(created_at: (options[:since_date]..Time.now))
            .desc(:points)
            .limit(options[:limit])
            .flatten.map { |score| score.sash.user }
    end

    def points
      score_points.sum(:num_points) || 0
    end

    class Point
      include Mongoid::Document
      include Mongoid::Timestamps

      field :num_points,    type: Integer, default: 0
      field :log,           type: String

      belongs_to :score, class_name: 'Merit::Score'
      has_many :activity_logs, class_name: 'Merit::ActivityLog', as: :related_change

      def sash_id
        score.sash_id
      end
    end
  end
end
