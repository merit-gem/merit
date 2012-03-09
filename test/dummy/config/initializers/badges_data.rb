# Create badges (Ambry)
badge_id = 0

# Rank badges (5 stars)
(1..5).each do |i|
  Badge.create!(
    :id => (badge_id = badge_id+1),
    :name => 'stars',
    :level => i
  )
end

# Normal badges
[
  {
    :id => (badge_id = badge_id+1),
    :name        => 'commenter',
    :description => 'You\'ve participated good in our boards!',
    :level       => 10
  }, {
    :id => (badge_id = badge_id+1),
    :name        => 'commenter',
    :description => 'You\'ve participated great in our boards!',
    :level       => 20
  }, {
    :id => (badge_id = badge_id+1),
    :name        => 'relevant-commenter',
    :description => 'You\'ve received 5 votes on a comment.',
    :level       => 5
  }, {
    :id => (badge_id = badge_id+1),
    :name        => 'autobiographer',
    :description => 'You\'ve edited your name and it\'s above 4 characters! (?)'
  }, {
    :id => (badge_id = badge_id+1),
    :name => 'just-registered'
  }
].each do |badge|
  Badge.create! badge
end