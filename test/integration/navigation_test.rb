require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase

  def tear_down
    DummyObserver.unstub(:update)
  end

  test 'user sign up should grant badge to itself' do
    DummyObserver.any_instance.expects(:update).times 1
    visit '/users/new'
    fill_in 'Name', with: 'Jack'
    assert_difference('Merit::ActivityLog.count') do
      click_button('Create User')
    end

    user = User.where(name: 'Jack').first
    assert_equal [Merit::Badge.by_name('just-registered').first], user.badges
  end

  test 'User#add_badge should add one badge, #rm_badge should delete one' do
    DummyObserver.any_instance.expects(:update).times 0

    user = User.create(name: 'test-user')
    assert_equal [], user.badges

    badge = Merit::Badge.first
    user.add_badge badge.id
    user.add_badge badge.id
    assert_equal [badge, badge], user.badges
    assert_equal [user], badge.users

    user.rm_badge badge.id
    assert_equal [badge], user.reload.badges
  end

  test 'Assigning a badge with a `points` attributes adds points' do
    DummyObserver.any_instance.expects(:update).times 0

    user = User.create(name: 'test-user')
    assert_equal [], user.badges

    badge = Merit::Badge.by_name('lottery-winner').first
    user.add_badge badge.id
    assert_equal badge.points, user.points
  end

  test 'Assigning a badge without a `points` attributes adds no points' do
    DummyObserver.any_instance.expects(:update).times 0

    user = User.create(name: 'test-user')
    assert_equal [], user.badges

    badge = Merit::Badge.first
    user.add_badge badge.id
    assert_equal 0, user.points
  end

  test 'Removing a badge with a `points` attributes subtracts points' do
    DummyObserver.any_instance.expects(:update).times 0

    user = User.create(name: 'test-user')
    assert_equal [], user.badges

    badge = Merit::Badge.by_name('lottery-winner').first
    user.add_badge badge.id
    user.rm_badge badge.id
    assert_equal 0, user.reload.points
  end

  test 'Remove inexistent badge should do nothing' do
    DummyObserver.any_instance.expects(:update).times 0
    user = User.create(name: 'test-user')
    assert_equal [], user.badges
    user.rm_badge 1
    assert_equal [], user.badges
  end

  test 'users#index should grant badge multiple times' do
    DummyObserver.any_instance.expects(:update).times 14
    user = User.create(name: 'test-user')

    # Multiple rule
    assert_difference 'badges_by_name(user, "gossip").count', 3 do
      3.times { visit '/users' }
    end

    # Namespaced controller
    assert_no_difference 'badges_by_name(user, "visited_admin").count' do
      visit '/users'
    end
    assert_difference 'badges_by_name(user, "visited_admin").count' do
      visit '/admin/users'
    end

    # Wildcard controllers
    assert_difference 'badges_by_name(user, "wildcard_badge").count', 3 do
      visit '/admin/users'
      visit '/api/users'
      visit '/users'
    end
  end

  test 'user workflow should grant some badges at some times' do
    DummyObserver.any_instance.expects(:update).at_least_once
    # Commented 9 times, no badges yet
    user = User.create(name: 'test-user')
    # Create needed friend user object
    friend = User.create(name: 'friend')

    (1..9).each do |i|
      Comment.create(
        name: "Title #{i}",
        comment: "Comment #{i}",
        user_id: user.id,
        votes: 8
      )
    end
    assert user.badges.empty?, 'Should not have badges'

    assert_equal 0, user.points
    assert_equal 0, Merit::Score::Point.count
    user.add_points 15
    assert_equal 15, user.points
    user.subtract_points 15
    assert_equal 0, user.points
    assert_equal 2, Merit::Score::Point.count

    # Tenth comment with errors doesn't change reputation
    badges = user.reload.badges
    points = user.points
    visit '/comments/new'
    assert_no_difference('Merit::ActivityLog.count') do
      click_button('Create Comment')
    end
    assert_equal badges, user.reload.badges
    assert_equal points, user.points

    # Tenth comment without errors, assert 10-commenter badge granted
    fill_in 'Name', with: 'Hi!'
    fill_in 'Comment', with: 'Hi bro!'
    fill_in 'User', with: user.id
    assert_difference('Merit::ActivityLog.count', 2) do
      click_button('Create Comment')
    end

    assert_equal [Merit::Badge.by_name('commenter').by_level(10).first], user.reload.badges
    assert_equal [Merit::Badge.by_name('has_commenter_friend').first], friend.reload.badges

    # Vote (to 5) a user's comment, assert relevant-commenter badge granted
    relevant_comment = user.comments.where(votes: 8).first
    visit '/comments'
    within("tr#c_#{relevant_comment.id}") do
      click_link '2'
    end

    relevant_badge = Merit::Badge.by_name('relevant-commenter').first
    user_badges    = User.where(name: 'test-user').first.badges
    assert user_badges.include?(relevant_badge), "User badges: #{user.badges.collect(&:name).inspect} should contain relevant-commenter badge."

    # Edit user's name by long name
    # tests ruby code in grant_on is being executed, and gives badge
    user = User.where(name: 'test-user').first
    user_badges = user.badges

    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'long_name!'
    click_button('Update User')

    user = User.where(name: 'long_name!').first
    autobiographer_badge = Merit::Badge.by_name('autobiographer').first
    assert user.badges.include?(autobiographer_badge), "User badges: #{user.badges.collect(&:name).inspect} should contain autobiographer badge."

    # Edit user's name by short name
    # tests ruby code in grant_on is being executed, and removes badge
    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'abc'
    assert_difference('Merit::ActivityLog.count', 2) do
      click_button('Update User')
    end

    # Check created Merit::ActivityLogs
    assert_equal 'granted commenter badge', Merit::ActivityLog.all[0].description
    assert_equal 'granted 20 points', Merit::ActivityLog.all[-1].description
    assert_equal 'removed autobiographer badge', Merit::ActivityLog.all[-2].description

    user = User.where(name: 'abc').first
    assert !user.badges.include?(autobiographer_badge), "User badges: #{user.badges.collect(&:name).inspect} should remove autobiographer badge."
  end

  test 'user workflow should add up points at some times' do
    DummyObserver.any_instance.expects(:update).at_least_once
    User.delete_all
    user = User.create(name: 'test-user')
    assert_equal 0, user.points, 'User should start with 0 points'

    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'a'
    assert_difference('Merit::ActivityLog.count', 2) do
      click_button('Update User')
    end

    user = User.where(name: 'a').first
    assert_equal 20, user.points, 'Updating info should grant 20 points'

    visit '/comments/new'
    click_button('Create Comment')

    user = User.where(name: 'a').first
    assert_equal 20, user.points, 'Empty comment should grant no points'

    visit '/comments/new'
    fill_in 'Name', with: 'Hi!'
    fill_in 'Comment', with: 'Hi bro!'
    fill_in 'User', with: user.id
    click_button('Create Comment')

    user = User.where(name: 'a').first
    assert_equal 20, user.points, 'Commenting should not grant 20 points if name.length <= 4'

    visit '/comments/new'
    fill_in 'Name', with: 'Hi there!'
    fill_in 'Comment', with: 'Hi bro!'
    fill_in 'User', with: user.id
    click_button('Create Comment')

    user = User.where(name: 'a').first
    assert_equal 40, user.points, 'Commenting should grant 20 points if name.length > 4'

    visit "/comments/#{Comment.last.id}/vote/4"
    user = User.first
    assert_equal 46, user.points, 'Voting comments should grant 5 points for voted, and 1 point for voting'
    assert_equal 5, user.points(category: 'vote'), 'Voting comments should grant 5 points for voted in vote category'

    visit '/comments/new'
    fill_in 'Name', with: 'Hi'
    fill_in 'Comment', with: '4'
    fill_in 'User', with: user.id
    click_button('Create Comment')

    user = User.where(name: 'a').first
    assert_equal 50, user.points, 'Commenting should grant the integer in comment points if comment is an integer'
  end

  test 'user workflow should grant levels at some times' do
    DummyObserver.any_instance.expects(:update).at_least_once
    user = User.create(name: 'test-user')
    assert user.badges.empty?

    # Edit user's name by 2 chars name
    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'ab'
    click_button('Update User')

    user = User.where(name: 'ab').first
    assert_equal 0, user.level, "User level should be 0."
    Merit::RankRules.new.check_rank_rules
    user.reload
    assert_equal 2, user.level, "User level should be 2."

    # Edit user's name by short name. Doesn't go back to previous rank.
    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'a'
    click_button('Update User')

    user = User.where(name: 'a').first
    Merit::RankRules.new.check_rank_rules
    user.reload
    assert_equal 2, user.level, "User level should be 2."

    # Edit user's name by 5 chars name
    visit "/users/#{user.id}/edit"
    fill_in 'Name', with: 'abcde'
    click_button('Update User')

    user = User.where(name: 'abcde').first
    Merit::RankRules.new.check_rank_rules
    user.reload
    assert_equal 5, user.level, "User level should be 5."
  end

  test 'assigning points to a group of records' do
    DummyObserver.any_instance.expects(:update).times 4
    commenter = User.create(name: 'commenter')
    comment_1 = commenter.comments.create(name: 'comment_1', comment: 'a')
    comment_2 = commenter.comments.create(name: 'comment_2', comment: 'b')

    visit comments_path
    # Thanks for voting point, to voted user and it's comments
    assert_difference('Merit::ActivityLog.count', 4) do
      within "tr#c_#{comment_2.id}" do
        click_link '1'
      end
    end

    comment_1.reload.points.must_be :==, 2
    comment_2.reload.points.must_be :==, 2
  end

  test 'api/comments#show should grant 1 point to user' do
    DummyObserver.any_instance.expects(:update).times 1
    user = User.create(name: 'test-user')
    assert_equal 0, user.points
    comment = user.comments.create!(name: 'test-comment', comment: 'comment body')

    visit "/api/comments/#{comment.id}"
    assert_equal 1, user.points
  end

  def badges_by_name(user, name)
    user.reload.badges.select{|b| b.name == name }
  end
end
