require 'test_helper'

describe Merit::Rule do
  before do
    @rule = Merit::Rule.new
  end

  describe '#applies (with block)' do
    before do
      @rule.block = ->(obj) { obj.length < 4 }
    end

    it 'truthy block should make rule apply' do
      @rule.applies?('str').must_be :==, true
    end

    it 'falsy block should make rule fail' do
      @rule.applies?('string').must_be :==, false
    end

    it 'block needs parameter for rule to pass' do
      @rule.applies?.must_be :==, false
    end
  end

  describe '#applies (without block)' do
    it 'empty condition should make rule apply' do
      @rule.applies?.must_be :==, true
    end
  end

  describe '#badge' do
    it 'raises exception on inexistent badge' do
      @rule.badge_name = 'inexistent'
      -> { @rule.badge }.must_raise Merit::BadgeNotFound
    end

    it 'finds related badge by name, when the name is a string' do
      Merit::Badge.create(id: 98, name: 'test-badge-98')
      @rule.badge_name = "test-badge-98"
      @rule.badge.must_be :==, Merit::Badge.find(98)
    end

    it 'finds related badge by name, when the name is a symbol' do
      Merit::Badge.create(id: 100, name: :testbadge)
      @rule.badge_name = 'testbadge'
      @rule.badge.must_be :==, Merit::Badge.find(100)
      @rule.badge
    end

    it 'finds related badge by name' do
      Merit::Badge.create(id: 98, name: 'test-badge-98')
      @rule.badge_id = 98
      @rule.badge.must_be :==, Merit::Badge.find(98)
    end
  end
end
