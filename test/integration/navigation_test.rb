require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  test "truth" do
    assert_kind_of Dummy::Application, Rails.application
  end

  test 'user workflow should grant some badges at some times' do
    # Create badges and user
    # FIXME: These should be fixtures.
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
        :description => 'You\'ve received 5 votes on a comment.',
        :level       => 5
      }, {
        :name => 'just-registered'
      }
    ])
    user = User.create!(:name => 'test-user')
    assert user.badges.empty?

    # Commented 9 times, no badges yet
    (1..9).each do |i|
      Comment.create(
        :name    => "Title #{i}",
        :comment => "Comment #{i}",
        :user_id => user.id,
        :votes   => 4
      )
    end
    assert user.badges.empty?, 'Should not have badges.'

    # Make tenth comment, assert 10-commenter badge granted
    visit '/comments/new'
    fill_in 'Name', :with => 'Hi!'
    fill_in 'User', :with => user.id
    click_button('Create Comment')

    assert_equal user.badges, [Badge.where(:name => 'commenter').where(:level => 10).first]

    # Vote (to 5) a user's comment, assert relevant-commenter badge granted
    relevant_comment = user.comments.where(:votes => 4).first
    visit '/comments'
    within("tr#c_#{relevant_comment.id}") do
      click_link 'Vote up!'
    end

    relevant_badge = Badge.where(:name => 'relevant-commenter').first
    user_badges    = User.where(:name => 'test-user').first.badges
    assert user_badges.include?(relevant_badge), "User badges: #{user.badges.collect(&:name).inspect} should contain relevant-commenter badge."
  end
end
