module Merit
  # Sash is a container for reputation data for meritable models. It's an
  # indirection between meritable models and badges and scores (one to one
  # relationship).
  #
  # It's existence make join models like badges_users and scores_users
  # unnecessary. It should be transparent at the application.
  class Sash < ActiveRecord::Base
    has_many :badges_sashes, :dependent => :destroy
    has_many :scores, :dependent => :destroy, :class_name => 'Merit::Score'

    after_create :create_scores

    def badges
      badge_ids.collect { |b_id| Badge.find(b_id) }
    end

    def badge_ids
      badges_sashes.map(&:badge_id)
    end

    def add_badge(badge_id)
      bs = BadgesSash.new(badge_id: badge_id)
      self.badges_sashes << bs
      bs
    end

    def rm_badge(badge_id)
      badges_sashes.find_by_badge_id(badge_id).try(:destroy)
    end


    def points(category = 'default')
      scores.where(:category => category).first.points
    end

    def add_points(num_points, log = 'Manually granted through `add_points`', category = 'default')
      point = Merit::Score::Point.new
      point.log = log
      point.num_points = num_points
      self.scores.where(:category => category).first.score_points << point
      point
    end

    def substract_points(num_points, log = 'Manually granted through `add_points`', category = 'default')
      add_points -num_points, log, category
    end

    private

    def create_scores
      self.scores << Merit::Score.create
    end
  end
end
