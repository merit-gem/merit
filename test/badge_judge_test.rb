require 'test_helper'

describe Merit::BadgeJudge do

  describe '#judge' do
    describe 'when the recipient is supposed to get a badge' do
      describe 'when sash was already granted the badge' do
        describe 'when the sash can get more than 1 badge' do
          it 'should award the badge' do
            sash = OpenStruct.new(badge_ids: [1, 3])
            rule = Merit::Rule.new
            rule.multiple = true
            rule.stubs(:badge).returns OpenStruct.new(id: 1)
            action = Merit::Action.new

            judge = Merit::BadgeJudge.new(sash, rule, action)
            judge.stubs(:rule_applies?).returns(true)
            judge.expects(:award_badge)
            judge.judge
          end
        end

        describe 'when the sash cannot have more than 1 of that badge' do
          it 'should not award the badge' do
            sash = OpenStruct.new(badge_ids: [1, 3])
            rule = Merit::Rule.new
            rule.multiple = false
            rule.stubs(:badge).returns OpenStruct.new(id: 1)
            action = Merit::Action.new

            judge = Merit::BadgeJudge.new(sash, rule, action)
            judge.stubs(:rule_applies?).returns(true)
            judge.expects(:award_badge).never
            judge.judge
          end
        end
      end

      describe 'when the sash has not been granted the badge' do
        it 'should award the badge' do
          sash = OpenStruct.new(badge_ids: [1, 3])
          rule = Merit::Rule.new
          rule.multiple = false
          rule.stubs(:badge).returns OpenStruct.new(id: 2)
          action = Merit::Action.new

          judge = Merit::BadgeJudge.new(sash, rule, action)
          judge.stubs(:rule_applies?).returns(true)
          judge.expects(:award_badge)
          judge.judge
        end
      end
    end

    describe 'when the recipient is not supposed to get the badge anymore' do
      describe 'when the badge was a temporary one' do
        it 'should remove the badge' do
          sash = OpenStruct.new(badge_ids: [1, 3])
          rule = Merit::Rule.new
          rule.multiple = false
          rule.stubs(:badge).returns OpenStruct.new(id: 2)
          action = Merit::Action.new

          target = OpenStruct
          judge = Merit::BadgeJudge.new(sash, rule, action)
          judge.stubs(:rule_applies?).returns(false)
          judge.expects(:remove_badge)
          judge.judge
        end
      end
    end
  end

end
