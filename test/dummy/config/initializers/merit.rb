# Use this hook to configure merit parameters
Merit.setup do |config|
  # Add application observers to get notifications any time merit changes reputation.
  config.add_observer 'DummyObserver'

  config.orm = ENV['ORM'].try(:to_sym)
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
}].each do |badge|
  Merit::Badge.create! badge
end
