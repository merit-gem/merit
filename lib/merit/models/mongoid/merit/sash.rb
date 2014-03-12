module Merit
  # Sash is a container for reputation data for meritable models. It's an
  # indirection between meritable models and badges and scores (one to one
  # relationship).
  #
  # It's existence make join models like badges_users and scores_users
  # unnecessary. It should be transparent at the application.
  class Sash
    include Mongoid::Document
    include Mongoid::Timestamps
    include Base::Sash

    has_many :badges_sashes, class_name: 'Merit::BadgesSash', dependent: :destroy
    has_many :scores, class_name: 'Merit::Score', dependent: :destroy

    after_create :create_scores

    # Retrieve all points from a category or none if category doesn't exist
    # By default retrieve all Points
    # @param category [String] The category
    # @return [ActiveRecord::Relation] containing the points
    def score_points(options = {})
      scope = scores
      if (category = options[:category])
        scope = scope.where(category: category)
      end
      Merit::Score::Point.where(:score_id.in => scope.map(&:_id))
    end
  end
end
