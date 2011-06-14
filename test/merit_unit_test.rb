require 'test_helper'

class MeritUnitTest < ActiveSupport::TestCase
  test "Hash#conditions_apply? tests if object responds what's expected" do
    hash = { :first => { :odd? => true }, :count => 2 }
    assert hash.conditions_apply? [1,3]
    assert not(hash.conditions_apply? [1,2,3])
    assert not(hash.conditions_apply? [2,3])
  end

  test "rule applies?" do
    rule = Merit::Rule.new
    assert rule.applies?, 'empty conditions should make rule apply'

    str = "string"
    rule.block = lambda{|obj| obj.length < 4 }
    assert !rule.applies?(str), 'block should make rule fail'

    rule.block = lambda{|obj| obj.length >= 4 }
    assert rule.applies?(str), 'block should make rule apply'
  end
end
