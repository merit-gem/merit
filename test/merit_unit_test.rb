require 'test_helper'

class MeritUnitTest < ActiveSupport::TestCase
  test "Rule applies?" do
    rule = Merit::Rule.new
    assert rule.applies?, 'empty conditions should make rule apply'

    str = "string"
    rule.block = lambda{|obj| obj.length < 4 }
    assert !rule.applies?(str), 'block should make rule fail'

    rule.block = lambda{|obj| obj.length >= 4 }
    assert rule.applies?(str), 'block should make rule apply'
  end

  test "BadgeSash knows it's related badge" do
    # No BadgeSash model for Mongoid
    return if ENV["ORM"] == "mongoid"

    Badge.create(:id => 99, :name => 'test-badge')
    badge_sash = BadgesSash.new
    badge_sash.badge_id = 99
    assert_equal Badge.find(99), badge_sash.badge
  end

  test "Badge#grant_to allow_multiple option" do
    badge = Badge.create(:id => 99, :name => 'test-badge')
    sash = Sash.create(:id => 99)
    assert_equal 0, sash.badge_ids.count
    badge.grant_to sash
    assert_equal 1, sash.reload.badge_ids.count
    badge.grant_to sash
    assert_equal 1, sash.reload.badge_ids.count
    badge.grant_to sash, :allow_multiple => true
    assert_equal 2, sash.reload.badge_ids.count
  end
end
