require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  setup do
    # Rank badges (5 stars)
    (1..5).each do |i|
      Badge.create(
        :name  => 'stars',
        :level => i
      )
    end

    # Normal badges
    Badge.create([
      {
        :name        => 'commenter',
        :description => 'You\'ve participated good in our boards!',
        :level       => 10
      }, {
        :name        => 'commenter',
        :description => 'You\'ve participated great in our boards!',
        :level       => 20
      }, {
        :name        => 'relevant-commenter',
        :description => 'You\'ve received 5 votes on a comment',
        :level       => 5
      }, {
        :name        => 'autobiographer',
      }, {
        :name => 'just-registered'
      }
    ])

    # Test user
    User.create(:name => 'test-user')
  end

  test 'user workflow should grant some badges at some times' do
    user = User.first
    assert user.badges.empty?

    # Commented 9 times, no badges yet
    (1..9).each do |i|
      Comment.create(
        :name    => "Title #{i}",
        :comment => "Comment #{i}",
        :user_id => user.id,
        :votes   => 8
      )
    end
    assert user.badges.empty?, 'Should not have badges'

    # Make tenth comment, assert 10-commenter badge granted
    visit '/comments/new'
    fill_in 'Name', :with => 'Hi!'
    fill_in 'User', :with => user.id
    click_button('Create Comment')

    user = User.where(:name => 'test-user').first
    assert_equal [Badge.where(:name => 'commenter').where(:level => 10).first], user.badges

    # Vote (to 5) a user's comment, assert relevant-commenter badge granted
    relevant_comment = user.comments.where(:votes => 8).first
    visit '/comments'
    within("tr#c_#{relevant_comment.id}") do
      click_link '2'
    end

    relevant_badge = Badge.where(:name => 'relevant-commenter').first
    user_badges    = User.where(:name => 'test-user').first.badges
    assert user_badges.include?(relevant_badge), "User badges: #{user.badges.collect(&:name).inspect} should contain relevant-commenter badge."

    # Edit user's name by long name
    # tests ruby code in grant_on is being executed, and gives badge
    user = User.where(:name => 'test-user').first
    user_badges = user.badges

    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'long_name!'
    click_button('Update User')

    user = User.where(:name => 'long_name!').first
    autobiographer_badge = Badge.where(:name => 'autobiographer').first
    assert user.badges.include?(autobiographer_badge), "User badges: #{user.badges.collect(&:name).inspect} should contain autobiographer badge."

    # Edit user's name by short name
    # tests ruby code in grant_on is being executed, and removes badge
    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'abc'
    click_button('Update User')

    user = User.where(:name => 'abc').first
    assert !user.badges.include?(autobiographer_badge), "User badges: #{user.badges.collect(&:name).inspect} should remove autobiographer badge."
  end

  test 'user workflow should add up points at some times' do
    user = User.first
    assert_equal 0, user.points, 'User should start with 0 points'

    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'a'
    click_button('Update User')

    user = User.where(:name => 'a').first
    assert_equal 20, user.points, 'Updating info should grant 20 points'

    visit '/comments/new'
    fill_in 'Name', :with => 'Hi!'
    fill_in 'User', :with => user.id
    click_button('Create Comment')

    user = User.where(:name => 'a').first
    assert_equal 40, user.points, 'Commenting should grant 20 points'

    visit "/comments/1/vote/4"
    user = User.first
    assert_equal 45, user.points, 'Voting comments should grant 5 points'
  end

  test 'user workflow should grant stars at some times' do
    user = User.first
    assert user.badges.empty?

    # Edit user's name by 2 chars name
    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'ab'
    click_button('Update User')

    user = User.where(:name => 'ab').first
    stars2 = Badge.where(:name => :stars, :level => 2).first
    assert_equal user.badges, [stars2], "User badges: #{user.badges.collect(&:name).inspect} should contain only 2-stars badge."

    # Edit user's name by short name. Doesn't go back to previous rank.
    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'a'
    click_button('Update User')

    user = User.where(:name => 'a').first
    assert_equal user.badges, [stars2], "User badges: #{user.badges.collect(&:name).inspect} should contain only 2-stars badge."

    # Edit user's name by 5 chars name
    visit "/users/#{user.id}/edit"
    fill_in 'Name', :with => 'abcde'
    click_button('Update User')

    user = User.where(:name => 'abcde').first
    stars5 = Badge.where(:name => :stars, :level => 5).first
    assert_equal user.badges.where(:name => :stars).count, 1, "Should not contain more than 2 stars ranking."
    assert user.badges.include?(stars5), "User badges: #{user.badges.collect(&:name).inspect} should contain 5-stars badge."
  end
end
