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
        _(collection).must_be :==, comment
      end
    end

    describe 'rule has no model_name' do
      it 'should fall back to the action#target_model' do
        rule = Merit::Rule.new
        rule.to = :itself
        action = Merit::Action.new(target_model: 'users', target_id: 3)
        user = User.new(id: 3)

        User.stubs(:find_by_id).with(3).returns(user)

        finder = Merit::BaseTargetFinder.new(rule, action)
        _(finder.find).must_be :==, user
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
        _(finder.find).must_be_nil
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
        _(finder.find.name).must_be :==, 'the comment name'
      end
    end
  end
end
