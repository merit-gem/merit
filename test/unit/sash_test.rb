require 'test_helper'

class SashTest < ActiveSupport::TestCase

  before do
    @sash = Merit::Sash.create
  end

  describe "#add_points" do

    describe "when category specified" do

      it "should create a new Point with specified category" do
        @sash.add_points 5, category: 'cat-et-gory'
        s = Merit::Score.last
        p = s.score_points.last

        assert_equal p.num_points, 5
        assert_equal s.category, 'cat-et-gory'
      end

    end

    it "should create a new Point in category default with specified number of points" do
      assert_difference("Merit::Score::Point.count", 1) { @sash.add_points 5 }
      s = Merit::Score.last
      p = s.score_points.last

      assert_equal p.num_points, 5
      assert_equal s.category, 'default'
    end

  end

  describe "#subtract_points" do

    describe "when category specified" do

      it "should create a new Point with specified category" do
        @sash.subtract_points 5, category: 'cat-et-gory'
        s = Merit::Score.last
        p = s.score_points.last

        assert_equal p.num_points, -5
        assert_equal s.category, 'cat-et-gory'
      end

    end

    it "should create a new Point in category default with inverse of specified number of points" do
      assert_difference("Merit::Score::Point.count", 1) { @sash.subtract_points 5 }
      s = Merit::Score.last
      p = s.score_points.last

      assert_equal p.num_points, -5
      assert_equal s.category, 'default'
    end

  end

  describe "#points" do

    before do
      @sash.add_points 5, category: 'cat-et-gory'
      @sash.add_points 7
    end


    describe "when category specified" do

      it "should retrieve the number of points of the category" do
        assert_equal 5, @sash.points(category: 'cat-et-gory')
      end

    end

    it "should retrieve the sum of points of all categories" do
      assert_equal 12, @sash.points
    end

  end

  describe "#score_points" do

    before do
      @point1 = @sash.add_points 5, category: 'cat-et-gory'
      @point2 = @sash.add_points 7
    end

    describe "when category specified" do

      it "should return the points of the category" do
        assert_equal 1, @sash.score_points(category: 'cat-et-gory').size
        assert @sash.score_points(category: 'cat-et-gory').include? @point1
        assert(!@sash.score_points(category: 'cat-et-gory').include?(@point2))
      end

      it "should return no Points if category doesn't exist" do
        assert_equal 0, @sash.score_points(category: 'cat').size
      end

    end

    it "should return all points" do
      assert_equal 2, @sash.score_points.size
      assert @sash.score_points.include? @point2
      assert @sash.score_points.include? @point1
    end

    it "should return no Points if no points found" do
      @sash1 = Merit::Sash.create
      assert_equal 0, @sash1.score_points.size
    end

  end

end
