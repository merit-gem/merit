commenter = User.create(:name => 'the-commenter-guy')
social = User.create(:name => 'social-skilled-man')

User.create(:name => 'bored-or-speechless')
User.create(:name => 'friend')

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