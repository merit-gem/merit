class BadgesSash < ActiveRecord::Base
  belongs_to :badge
  belongs_to :sash

  # TODO: Better way to do it? With composite keys ARel complained:
  # NoMethodError: undefined method `eq' for nil:NilClass
  #  from ~/.rvm/gems/ruby-1.9.2-p0/gems/activesupport-3.0.9/lib/active_support/whiny_nil.rb:48:in `method_missing'
  #  from ~/.rvm/gems/ruby-1.9.2-p0/gems/activerecord-3.0.9/lib/active_record/persistence.rb:259:in `update'
  def set_notified!(badge, sash)
    ActiveRecord::Base.connection.execute("UPDATE badges_sashes
      SET notified_user = TRUE
      WHERE badge_id = #{badge.id} AND sash_id = #{sash.id}")
  end
end
