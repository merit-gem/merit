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
    :name        => 'autobiographer',
    :description => 'You\'ve edited your name and it\'s above 4 characters! (?)'
  }, {
    :name => 'just-registered'
  }
])

commenter = User.create(:name => 'the-commenter-guy')
social = User.create(:name => 'social-skilled-man')
bored  = User.create(:name => 'bored-or-speechless')

(1..9).each do |i|
  Comment.create(
    :name    => "Title #{i}",
    :comment => "Comment #{i}",
    :user_id => social.id,
    :votes   => 3
  )
  Comment.create(
    :name    => "Title #{i}",
    :comment => "Comment #{i}",
    :user_id => commenter.id
  )
end