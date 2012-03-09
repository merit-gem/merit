class BadgesSash < ActiveRecord::Base
  belongs_to :badge
  belongs_to :sash

  # To be used in the application, mark badge granting as notified to user
  def set_notified!(badge, sash)
    # With composite keys ARel complained, had to use SQL
    ActiveRecord::Base.connection.execute("UPDATE badges_sashes
      SET notified_user = TRUE
      WHERE badge_id = #{badge.id} AND sash_id = #{sash.id}")
  end
end
