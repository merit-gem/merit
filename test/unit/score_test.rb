require 'test_helper'

describe Merit::Score do
  it 'Point#sash_id delegates to Score' do
    score = mock()
    score.stubs(:sash_id).returns(33)

    point = Merit::Score::Point.new
    point.stubs(:score).returns(score)

    point.sash_id.must_be :==, score.sash_id
  end
end
