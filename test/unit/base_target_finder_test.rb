require 'test_helper'

describe Merit::BaseTargetFinder do
  describe '#find' do
    describe 'rule has a model_name' do
      it "should prioritize the rule's model name" do
        rule = Merit::Rule.new
        rule.to = :itself
        rule.model_name = 'comment'
        action = Merit::Action.new(target_model: 'users', target_id: 2)
        comment = Comment.new

        Comment.stubs(:find_by_id).with(2).returns(comment)

        finder = Merit::BaseTargetFinder.new(rule, action)
        collection = finder.find
        collection.must_be :==, comment
      end
    end

    describe 'rule has no model_name' do
      it 'should fall back to the action#target_model' do
        rule = Merit::Rule.new
        rule.to = :itself
        action = Merit::Action.new(target_model: 'players', target_id: 3)
        user = Player.new(id: 3)

        Player.stubs(:find_by_id).with(3).returns(user)

        finder = Merit::BaseTargetFinder.new(rule, action)
        finder.find.must_be :==, user
      end
    end

    describe 'when the targeted class is not meritable' do
      it 'should warn and return' do
        rule = Merit::Rule.new
        rule.to = :itself
        rule.model_name = 'registrations'
        action = Merit::Action.new(target_model: 'users', target_id: 220)

        finder = Merit::BaseTargetFinder.new(rule, action)
        Rails.logger.expects(:warn)
        finder.find.must_be_nil
      end
    end

    describe 'target was destroyed' do
      it 'gets the object from the JSON data in the merit_actions table' do
        comment = Comment.new(name: 'the comment name')

        rule = Merit::Rule.new
        rule.to = :itself
        rule.model_name = 'comment'
        action = Merit::Action.new(target_model: 'comment',
                                   target_id: 2,
                                   target_data: comment.to_yaml)

        finder = Merit::BaseTargetFinder.new(rule, action)
        finder.find.name.must_be :==, 'the comment name'
      end
    end

    describe 'warns when the target_data column has not been created' do
      it 'sends a message to the logger' do
        comment = Comment.new(name: 'the comment name')

        rule = Merit::Rule.new
        rule.to = :itself
        rule.model_name = 'comment'
        action = Merit::Action.new(target_model: 'comment',
                                   target_id: 2,
                                   target_data: comment.to_yaml)
        action.stubs(:respond_to?).with(:target_data).returns(false)

        Rails.logger.expects(:warn)

        finder = Merit::BaseTargetFinder.new(rule, action)
        finder.reanimate_target_from_action
      end
    end
  end
end
