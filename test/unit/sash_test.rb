require 'test_helper'

describe Merit::Sash do
  
  before do
    @sash = Merit::Sash.new
  end
  
  describe "#add_points" do
    
    it "should create a new point with specified log, in the score with the category" do
      bef = Merit::Score::Point.count
      @sash.add_points 5, 'log-a-rythm', 'cat-et-gory'
      s = Merit::Score.last
      p = s.score_points.last
      aft = Merit::Score::Point.count
      
      assert bef + 1 == aft
      assert p.num_points == 5
      assert p.log == 'log-a-rythm'
      assert s.category == 'cat-et-gory'
    end
    
  end
    
end
    
   