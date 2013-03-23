require 'test_helper'

describe Merit::SashFinder do

  it 'should return an array of sashes of the target objects' do
    sash_1 = Sash.new
    user_1 = User.new(:_sash => sash_1)
    user_1.stubs(:_sash).returns(sash_1)

    sash_2 = Sash.new
    user_2 = User.new
    user_2.stubs(:_sash).returns(sash_2)

    object_without_sash = OpenStruct.new

    users = [user_1, user_2, object_without_sash]

    rule = Merit::Rule.new
    action = Merit::Action.new

    finder = Merit::SashFinder.new(rule, action)
    finder.stubs(:targets).returns(users)
    sashes = finder.find
    sashes.size.must_be :==, 2
    sashes.must_include sash_1
    sashes.must_include sash_2
  end

end
