require 'test_helper'

describe Merit::Score do
  describe 'Point#sash_id delegates to Score' do
    it 'selects matching rules (suffix)' do
      score = Merit::Score.new(sash_id: 2)
      point = Merit::Score::Point.new(score: score)
      point.sash_id.must_be :==, score.sash_id
    end
  end
end
