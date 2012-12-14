require 'test_helper'

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

  test "Extends only meritable ActiveRecord models" do
    class MeritableModel < ActiveRecord::Base
      def self.columns; @columns ||= []; end
      has_merit
    end
    class OtherModels < ActiveRecord::Base
      def self.columns; @columns ||= []; end
    end
    assert MeritableModel.method_defined?(:points), 'Meritable model should respond to merit methods'
    assert !OtherModels.method_defined?(:points), 'Other models shouldn\'t respond to merit methods'
  end

  # Do we need this non-documented attribute?
  test "BadgesSash#set_notified! sets boolean attribute" do
    badge_sash = BadgesSash.new
    assert !badge_sash.notified_user
    badge_sash.set_notified!
    assert badge_sash.notified_user
  end

  test 'unknown ranking should raise merit exception' do
    class WeirdRankRules
      include Merit::RankRulesMethods
      def initialize
        set_rank :level => 1, :to => User, :level_name => :clown do |user|
        end
      end
    end
    assert_raises Merit::RankAttributeNotDefined do
      WeirdRankRules.new.check_rank_rules
    end
  end
end
