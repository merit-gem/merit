Badge.create([
  {
    :name        => 'commenter',
    :description => 'You\'ve participated good in our boards!',
    :level       => 10
  }, {
    :name        => 'commenter',
    :description => 'You\'ve participated great in our boards!',
    :level       => 20
  }
])

commenter = User.create(:name => 'the-commenter-guy')
social = User.create(:name => 'social-skilled-man')
bored  = User.create(:name => 'bored-or-speechless')

(1..9).each do |i|
  Comment.create(
    :name    => "Title #{i}",
    :comment => "Comment #{i}",
    :user_id => social.id
  )
end

(1..19).each do |i|
  Comment.create(
    :name    => "Title #{i}",
    :comment => "Comment #{i}",
    :user_id => commenter.id
  )
end