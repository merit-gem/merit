require 'test_helper'

# TODO: Split different objects tests in it's own files
class MeritUnitTest < ActiveSupport::TestCase
  test 'extends only meritable ActiveRecord models' do
    class User < ActiveRecord::Base
      def self.columns; @columns ||= []; end
      has_merit
    end
    class Fruit < ActiveRecord::Base
      def self.columns; @columns ||= []; end
    end

    assert User.method_defined?(:points), 'has_merit adds methods'
    assert !Fruit.method_defined?(:points), 'other models aren\'t extended'
  end

  test 'Badges get "related_models" methods' do
    class Soldier < ActiveRecord::Base
      def self.columns; @columns ||= []; end
      has_merit
    end
    class Player < ActiveRecord::Base
      def self.columns; @columns ||= []; end
      has_merit
    end
    assert Merit::Badge.method_defined?(:soldiers), 'Badge#soldiers should be defined'
    assert Merit::Badge.method_defined?(:players), 'Badge#players should be defined'
  end

  test 'Badge#last_granted returns recently granted badges' do
    # Create sashes, badges and badges_sashes
    sash = Fabricate(:sash)
    badge = Fabricate(:badge)
    sash.add_badge badge.id
    Merit::BadgesSash.last.update_attribute :created_at, 1.day.ago
    sash.add_badge badge.id
    Merit::BadgesSash.last.update_attribute :created_at, 8.days.ago
    sash.add_badge badge.id
    Merit::BadgesSash.last.update_attribute :created_at, 15.days.ago

    # Test method options
    assert_equal Merit::Badge.last_granted(since_date: Time.now), []
    assert_equal Merit::Badge.last_granted(since_date: 1.week.ago), [badge]
    assert_equal Merit::Badge.last_granted(since_date: 2.weeks.ago).count, 2
    assert_equal Merit::Badge.last_granted(since_date: 2.weeks.ago, limit: 1), [badge]
  end

  test 'Merit::Score.top_scored returns scores leaderboard' do
    # Create sashes and add points
    sash_1 = Fabricate(:sash)
    sash_1.add_points(10); sash_1.add_points(10)
    sash_2 = Fabricate(:sash)
    sash_2.add_points(5); sash_2.add_points(5)

    # Test method options
    assert_equal Merit::Score.top_scored(table_name: :sashes),
      [{'sash_id'=>sash_1.id, 'sum_points'=>20, 0=>1, 1=>20},
       {'sash_id'=>sash_2.id, 'sum_points'=>10, 0=>2, 1=>10}]
    assert_equal Merit::Score.top_scored(table_name: :sashes, limit: 1),
      [{'sash_id'=>sash_1.id, 'sum_points'=>20, 0=>1, 1=>20}]
  end

  test 'unknown ranking raises exception' do
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
