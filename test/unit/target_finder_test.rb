require 'test_helper'

describe Merit::TargetFinder do
  describe '#find' do
    describe 'rule#to is :itself' do
      it 'should return the base target' do
        rule = Merit::Rule.new
        rule.to = :itself
        action = Merit::Action.new

        comment = Comment.new

        Merit::BaseTargetFinder
          .stubs(:find)
          .with(rule, action)
          .returns(comment)

        finder = Merit::TargetFinder.new(rule, action)
        collection = finder.find
        collection.size.must_be :==, 1
        collection.must_include comment
      end
    end

    describe 'rule#to is :action_user' do
      before do
        Merit.setup { |config| config.user_model_name = 'Player' }
      end
      after do
        Merit.setup { |config| config.user_model_name = 'User' }
      end

      it 'should return an array including user that executed the action' do
        rule = Merit::Rule.new
        rule.to = :action_user
        action = Merit::Action.new(user_id: 22)
        user = Player.new

        Player.stubs(:find_by_id).with(22).returns(user)

        finder = Merit::TargetFinder.new(rule, action)
        collection = finder.find
        collection.size.must_be :==, 1
        collection.must_include user
      end

      describe 'when user does not exist' do
        it 'should return warn and return an empty array' do
          rule = Merit::Rule.new
          rule.to = :action_user
          action = Merit::Action.new(user_id: 22)

          Rails.logger.expects(:warn).with('[merit] no Player found with id 22')
          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_empty
        end
      end
    end

    describe 'rule#to is defined but neither :itself or :action_user' do
      it 'should return the corresponding object on the original target' do
        rule = Merit::Rule.new
        rule.to = :user
        rule.model_name = 'comments'
        action = Merit::Action.new(target_id: 40)

        user = Player.new
        comment = Comment.new
        comment.stubs(:user).returns(user)
        Comment.stubs(:find_by_id).with(40).returns(comment)

        finder = Merit::TargetFinder.new(rule, action)
        collection = finder.find
        collection.size.must_be :==, 1
        collection.must_include user
      end

      describe 'rule#to does not exist as a method on the original target' do
        it 'should warn and return an empty array' do
          rule = Merit::Rule.new
          rule.to = :non_existent
          rule.model_name = 'comments'
          action = Merit::Action.new(target_id: 40)

          comment = Comment.new
          Comment.stubs(:find_by_id).with(40).returns(comment)

          str = '[merit] NoMethodError on `Comment#non_existent`'
          str << ' (called from Merit::TargetFinder#other_target)'

          Rails.logger.expects(:warn).with(str)
          finder = Merit::TargetFinder.new(rule, action)
          finder.find.must_be_empty
        end
      end
    end
  end
end
