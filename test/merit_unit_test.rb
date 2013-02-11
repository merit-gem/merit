require 'test_helper'

class MeritableModel < ActiveRecord::Base
  def self.columns; @columns ||= []; end
  has_merit
end

class OtherModels < ActiveRecord::Base
  def self.columns; @columns ||= []; end
end

class MeritUnitTest < ActiveSupport::TestCase
  test "Rule#applies? should depend on provided block" do
    rule = Merit::Rule.new
    assert rule.applies?, 'empty conditions should make rule apply'

    str = "string"
    rule.block = lambda{|obj| obj.length < 4 }
    assert !rule.applies?(str), 'block should make rule fail'

    rule.block = lambda{|obj| obj.length >= 4 }
    assert rule.applies?(str), 'block should make rule apply'

    rule.block = lambda{|obj| true }
    assert !rule.applies?, 'block which expects object should return false if no argument'
  end

  test "Rule#badge should get related badge or raise Merit::BadgeNotFound" do
    rule = Merit::Rule.new
    rule.badge_name = 'inexistent'
    assert_raise Merit::BadgeNotFound do
      rule.badge
    end

    badge = Badge.create(:id => 98, :name => 'test-badge-98')
    rule.badge_name = badge.name
    assert_equal Badge.find(98), rule.badge
  end

  test "Merit::Action#log_activity doesn't grow larger than 240 chars" do
    m = Merit::Action.create
    m.log_activity('a' * 250)
    assert m.log.length <= 240, 'Log shouldn\'t grow larger than 240 chars'
  end

  test "Extends only meritable ActiveRecord models" do
    assert MeritableModel.method_defined?(:points), 'Meritable model should respond to merit methods'
    assert !OtherModels.method_defined?(:points), 'Other models shouldn\'t respond to merit methods'
  end

  test "Badges get 'related_models' method" do
    assert Badge.method_defined?(:meritable_models), 'Badge#meritable_models should be defined'
  end

  # Do we need this non-documented attribute?
  test "BadgesSash#set_notified! sets boolean attribute" do
    badge_sash = BadgesSash.new
    assert !badge_sash.notified_user
    badge_sash.set_notified!
    assert badge_sash.notified_user
  end

  test "Badge#last_granted returns recently granted badges" do
    sash = Sash.create
    badge = Badge.create(id: 20, name: 'test-badge-21')
    sash.add_badge badge.id
    BadgesSash.last.update_attribute :created_at, 1.day.ago
    sash.add_badge badge.id
    BadgesSash.last.update_attribute :created_at, 8.days.ago
    sash.add_badge badge.id
    BadgesSash.last.update_attribute :created_at, 15.days.ago

    assert_equal Badge.last_granted(since_date: Time.now), []
    assert_equal Badge.last_granted(since_date: 1.week.ago), [badge]
    assert_equal Badge.last_granted(since_date: 2.weeks.ago).count, 2
    assert_equal Badge.last_granted(since_date: 2.weeks.ago, limit: 1), [badge]
  end

  test "Merit::Score.top_scored returns scores leaderboard" do
    sash_1 = Sash.create
    sash_1.add_points(10); sash_1.add_points(10)
    sash_2 = Sash.create
    sash_2.add_points(5); sash_2.add_points(5)

    assert_equal Merit::Score.top_scored(table_name: :sashes),
      [{"sash_id"=>1, "sum_points"=>20, 0=>1, 1=>20},
       {"sash_id"=>2, "sum_points"=>10, 0=>2, 1=>10}]
    assert_equal Merit::Score.top_scored(table_name: :sashes, limit: 1),
      [{"sash_id"=>1, "sum_points"=>20, 0=>1, 1=>20}]
  end

  test 'unknown ranking should raise merit exception' do
    class WeirdRankRules
      include Merit::RankRulesMethods
      def initialize
        set_rank level: 1, to: User, level_name: :clown
      end
    end
    assert_raises Merit::RankAttributeNotDefined do
      WeirdRankRules.new.check_rank_rules
    end
  end
end
