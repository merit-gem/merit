require 'test_helper'

describe Merit::SashFinder do
  it 'should return an array of sashes of the target objects' do
    sash_1 = Merit::Sash.new
    user_1 = Player.new
    user_1.stubs(:_sash).returns(sash_1)

    sash_2 = Merit::Sash.new
    user_2 = Player.new
    user_2.stubs(:_sash).returns(sash_2)

    # TODO: With stub we are not exercising compact
    # object_without_sash = OpenStruct.new
    # users = [user_1, user_2, object_without_sash]
    users = [user_1, user_2]

    rule = Merit::Rule.new
    action = Merit::Action.new

    Merit::SashFinder.stubs(:targets).returns(users)
    sashes = Merit::SashFinder.find(rule, action)
    sashes.count.must_be :==, 2
    sashes.must_include sash_1
    sashes.must_include sash_2
  end
end
