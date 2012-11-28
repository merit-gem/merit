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

  test "Rule#badge should get related badge or raise Merit exception" do
    rule = Merit::Rule.new
    rule.badge_name = 'inexistent'
    assert_raise Merit::BadgeNotFound do
      rule.badge
    end

    badge = Badge.create(:id => 98, :name => 'test-badge-98')
    rule.badge_name = badge.name
    assert_equal Badge.find(98), rule.badge
  end

  test "Extending only certain ActiveRecord models" do
    class MeritableModel < ActiveRecord::Base
      def self.columns; @columns ||= []; end
      has_merit
    end
    assert MeritableModel.method_defined?(:points), 'Meritable model should respond to merit methods'
    assert !ActiveRecord::Base.method_defined?(:points), 'ActiveRecord::Base shouldn\'t respond to merit methods'
  end

  # Do we need this non-documented attribute?
  test "BadgesSash#set_notified! sets boolean attribute" do
    badge_sash = BadgesSash.new
    assert !badge_sash.notified_user
    badge_sash.set_notified!
    assert badge_sash.notified_user
  end

  test "Badge#grant_to allow_multiple option" do
    badge = Badge.create(:id => 99, :name => 'test-badge')
    sash = Sash.create(:id => 99)

    assert_equal 0, sash.badge_ids.count

    assert badge.grant_to(sash)
    assert_equal 1, sash.badge_ids.count
    assert !badge.grant_to(sash)
    assert_equal 1, sash.badge_ids.count

    assert badge.grant_to(sash, :allow_multiple => true)
    assert_equal 2, sash.badge_ids.count
  end
end
