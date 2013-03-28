require 'test_helper'

describe Merit::PointJudge do

  describe '#judge' do
    describe 'when the rule applies' do
      it 'should add the points to the sash, and log' do
        sash = OpenStruct.new
        rule = Merit::Rule.new
        rule.score = 22
        action = Merit::Action.new

        sash.expects(:add_points).with(22, action.inspect[0..240])
        action.expects(:log_activity).with("points_granted:22")

        judge = Merit::PointJudge.new(sash, rule, action)
        judge.judge
      end
    end

    describe 'when the rule does not apply' do
      it 'should do nothing' do
        judge = Merit::PointJudge.new(nil, nil, nil)
        judge.stubs(:rule_applies?).returns(false)
        judge.judge.must_be_nil
      end
    end
  end

end
