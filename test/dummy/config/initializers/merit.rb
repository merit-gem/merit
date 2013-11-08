# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be:active_record (default), :mongo_mapper and :mongoid
  # config.orm = :active_record
end

# Create application badges (uses https://github.com/norman/ambry)
badge_id = 0
[{
  id: (badge_id = badge_id+1),
  name: 'commenter',
  description: 'You\'ve participated good in our boards! (level 10)',
  level: 10
}, {
  id: (badge_id = badge_id+1),
  name: 'commenter',
  description: 'You\'ve participated great in our boards!'
}, {
  id: (badge_id = badge_id+1),
  name: 'visited_admin',
  description: 'You sneaked in!'
}, {
  id: (badge_id = badge_id+1),
  name: 'has_commenter_friend',
  description: 'Testing badge granting in more than one rule per action, with different targets'
}, {
  id: (badge_id = badge_id+1),
  name: 'relevant-commenter',
  description: 'You\'ve received 5 votes on a comment.'
}, {
  id: (badge_id = badge_id+1),
  name: 'autobiographer',
  description: 'You\'ve edited your name and it\'s above 4 characters! (?)'
}, {
  id: (badge_id = badge_id+1),
  name: 'just-registered'
}, {
  id: (badge_id = badge_id+1),
  name: 'wildcard_badge'
}, {
  id: (badge_id = badge_id+1),
  name: 'gossip'
}, {
  id: (badge_id = badge_id+1),
  name: 'only_certain_users'
}].each do |badge|
  Merit::Badge.create! badge
end
