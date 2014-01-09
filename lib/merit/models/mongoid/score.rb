#module Merit
  class Score
    include Mongoid::Document
    include Mongoid::Timestamps

    field :category,      type: String, default: 'default'


    belongs_to :sash
    has_many :score_points, class_name: 'Score::Point', dependent: :destroy

    def self.top_scored(options = {})
      #coming soon
    end

    def points
      score_points.sum(:num_points) || 0
    end

    class Point
      include Mongoid::Document
      include Mongoid::Timestamps

      field :num_points,    type: Integer, default: 0
      field :log,           type: String

      belongs_to :score, class_name: 'Score'
      has_many :activity_logs, class_name: 'ActivityLog', as: :related_change
    end
  end
#end
