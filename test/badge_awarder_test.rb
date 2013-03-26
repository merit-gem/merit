require 'test_helper'

describe Merit::BadgeAwarder do

  describe '#invoke' do
    describe 'when the rule#to is :action_user' do
      it 'should add the badge to the given sash, and log activity' do
        badge = OpenStruct.new(id: 22)
        sash = OpenStruct.new
        rule = Merit::Rule.new
        rule.to = :action_user
        rule.stubs(:badge).returns(badge)
        action = Merit::Action.new

        sash.expects(:add_badge).with(22)
        action.expects(:log_activity).
          with('badge_granted_to_action_user:22')

        handler = Merit::BadgeAwarder.new(sash, rule, action)
        handler.award
      end
    end

    describe 'when the rule#to is not :action_user' do
      it 'should add the badge to the sash, and log a generic message' do
        badge = OpenStruct.new(id: 24)
        sash = OpenStruct.new
        rule = Merit::Rule.new
        rule.to = :something_else
        rule.stubs(:badge).returns(badge)
        action = Merit::Action.new

        sash.expects(:add_badge).with(24)
        action.expects(:log_activity).with('badge_granted:24')

        handler = Merit::BadgeAwarder.new(sash, rule, action)
        handler.award
      end
    end
  end

end
