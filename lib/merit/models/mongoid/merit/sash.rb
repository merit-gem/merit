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

    def add_badge(badge_id)
      bs = Merit::BadgesSash.new(badge_id: badge_id)
      badges_sashes.push(bs)
    end

    def rm_badge(badge_id)
      bs = badges_sashes.where(badge_id: badge_id).first
      badges_sashes.delete(bs)
    end
  end
end
