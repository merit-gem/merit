require 'test_helper'

describe Merit::TargetFinder do

  describe '#find' do
    describe 'rule#to is :itself' do
      describe 'rule has a model_name' do
        it "should prioritize the rule's model name" do
          rule = Merit::Rule.new
          rule.to = :itself
          rule.model_name = 'comment'
          action = Merit::Action.new(target_model: 'users', target_id: 2)
          comment = Comment.new

          Comment.stubs(:find_by_id).with(2).returns(comment)

          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_same_as comment
        end
      end

      describe 'rule has no model_name' do
        it "should fall back to the action#target_model" do
          rule = Merit::Rule.new
          rule.to = :itself
          action = Merit::Action.new(target_model: 'users', target_id: 3)
          user = Comment.new(id: 3)

          User.stubs(:find_by_id).with(3).returns(user)

          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_same_as user
        end
      end
    end

    describe 'rule#to is :action_user' do
      it 'should return the user that executed the action' do
        Merit.user_model_name = 'User'
        rule = Merit::Rule.new
        rule.to = :action_user
        action = Merit::Action.new(user_id: 22)
        user = User.new

        User.stubs(:find_by_id).with(22).returns(user)

        finder = Merit::TargetFinder.new(rule, action)
        finder.find.must_be_same_as user
      end

      describe 'when user does not exist' do
        it 'should return warn and return nil' do
          Merit.user_model_name = 'User'
          rule = Merit::Rule.new
          rule.to = :action_user
          action = Merit::Action.new(user_id: 22)

          Rails.logger.expects(:warn).with("[merit] no User found with id 22")
          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_nil
        end
      end
    end

    describe 'rule#to is defined but neither :itself or :action_user' do
      it 'should return the corresponding object on the original target' do
        rule = Merit::Rule.new
        rule.to = :user
        rule.model_name = 'comments'
        action = Merit::Action.new(target_id: 40)

        user = User.new
        comment = Comment.new
        comment.stubs(:user).returns(user)
        Comment.stubs(:find_by_id).with(40).returns(comment)

        finder = Merit::TargetFinder.new(rule, action)
        finder.find.must_be_same_as user
      end

      describe 'the rule#to does not exist as a method on the original target' do
        it 'should warn and return nil' do
          rule = Merit::Rule.new
          rule.to = :non_existent
          rule.model_name = 'comments'
          action = Merit::Action.new(target_id: 40)

          comment = Comment.new
          Comment.stubs(:find_by_id).with(40).returns(comment)

          message = "[merit] NoMethodError on `Comment#non_existent`"
          message << " (called from Merit::TargetFinder#other_target)"

          Rails.logger.expects(:warn).with(message)
          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_nil
        end
      end
    end
  end

end
