Badge.create(
  :name        => 'commenter',
  :description => 'You\'ve participated good in our boards!',
  :level       => 10
)

social = User.create(:name => 'social-skilled-man')
bored  = User.create(:name => 'boredom')

(1..9).each do |i|
  Comment.create(
    :name    => "Title #{i}",
    :comment => "Comment #{i}",
    :user_id => social.id
  )
end