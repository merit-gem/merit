require 'test_helper'

# TODO: Split different objects tests in it's own files
class MeritUnitTest < ActiveSupport::TestCase
  require "orm_models/#{Merit.orm}"

  test 'extends only meritable models' do
    assert Player.method_defined?(:points), 'has_merit adds methods'
    assert !Fruit.method_defined?(:points), 'other models aren\'t extended'
  end

  test 'Badges get "related_models" methods' do
    assert Merit::Badge.method_defined?(:soldiers), 'Badge#soldiers should be defined'
    assert Merit::Badge.method_defined?(:players), 'Badge#players should be defined'
  end

  test 'unknown ranking raises exception' do
    class WeirdRankRules
      include Merit::RankRulesMethods
      def initialize
        set_rank level: 1, to: Player, level_name: :clown
      end
    end
    assert_raises Merit::RankAttributeNotDefined do
      WeirdRankRules.new.check_rank_rules
    end
  end

  test 'Badge#custom_fields_hash saves correctly' do
    Merit::Badge.create(id: 99,
                        name: 'test-badge',
                        custom_fields: { key_1: 'value1' })
    assert_equal 'value1', Merit::Badge.find(99).custom_fields[:key_1]
  end
end
