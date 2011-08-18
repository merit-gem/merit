require 'test_helper'

class MeritUnitTest < ActiveSupport::TestCase
  test "Hash#conditions_apply? tests if object responds what's expected" do
    hash = { :first => { :odd? => true }, :count => 2 }
    assert hash.conditions_apply? [1,3]
    assert not(hash.conditions_apply? [1,2,3])
    assert not(hash.conditions_apply? [2,3])
  end

  test "Rule applies?" do
    rule = Merit::Rule.new
    assert rule.applies?, 'empty conditions should make rule apply'

    str = "string"
    rule.block = lambda{|obj| obj.length < 4 }
    assert !rule.applies?(str), 'block should make rule fail'

    rule.block = lambda{|obj| obj.length >= 4 }
    assert rule.applies?(str), 'block should make rule apply'
  end

  test "Sash#latest should return 5 non-repeated sashes ordered by latest badges granting date (desc)" do
    (1..6).each{|i|
      s = Sash.create
      b1 = Badge.create(name: "badge #{i} 1").grant_to s
      b2 = Badge.create(name: "badge #{i} 2").grant_to s
    }
    assert_equal Sash.latest_badges(5).all, Sash.order('id DESC').limit(5).all
  end
end
