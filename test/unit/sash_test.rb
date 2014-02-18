require 'test_helper'

class SashTest < ActiveSupport::TestCase

  before do
    @sash = Merit::Sash.create
  end

  describe "#add_points" do

    describe "when category specified" do

      it "should create a new point, in the score with specified category" do
        @sash.add_points 5, 'Manually granted', 'cat-et-gory'
        s = Merit::Score.last
        p = s.score_points.last

        assert_equal p.num_points, 5
        assert_equal s.category, 'cat-et-gory'
      end

    end

    describe "when log specified" do

      it "should create a new point with specified log" do
        @sash.add_points 5, 'log-a-rythm'
        p = Merit::Score.last.score_points.last

        assert_equal p.num_points, 5
        assert_equal p.log, 'log-a-rythm'
      end

    end

    it "should create a new point" do
      assert_difference("Merit::Score::Point.count", 1) { @sash.add_points 5 }
      s = Merit::Score.last
      p = s.score_points.last

      assert_equal p.num_points, 5
      assert_equal p.log, 'Manually granted'
      assert_equal s.category, 'default'
    end

  end

  describe "#points" do

    describe "when category specified" do

      it "should retrieve the number of points of the category" do
        @sash.add_points 5, 'log-a-rythm', 'cat-et-gory'

        assert_equal 0, @sash.points
        assert_equal 5, @sash.points('cat-et-gory')
      end

    end

    it "should retrieve the number of points of category default" do
      @sash.add_points 5

      assert_equal 5, @sash.points
    end

  end

  describe "#all_points" do

    it "should retrieve the sum of points of all categories" do
      @sash.add_points 5, 'log-a-rythm', 'cat-et-gory'
      @sash.add_points 7

      assert_equal 12, @sash.points(:all)
    end

  end

end


