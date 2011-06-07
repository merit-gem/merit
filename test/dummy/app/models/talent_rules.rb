# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+:votes => 5+ for instance).
#
# +grant_on+ can have a +:to+ option, which can be either +related_user+ or
# +action_user+ (default). The former applies the badge to the target object's
# related user (+post.user+ for instance), while the latter to the user who
# triggered the action (+current_user+, or "source").
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

class TalentRules
  include Talent::Rules

  def initialize
    # If it creates user, grant badge
    grant_on 'users#create', :badge => 'just-registered'

    # If it has 10 comments, grant commenter-10 badge
    grant_on 'comments#create', :badge => 'commenter', :level => 10 do
      { :user => { :comments => { :count => 10 } } }
    end

    # If it has 5 votes, grant relevant-commenter badge
    grant_on 'comments#vote', :badge => 'relevant-commenter', :to => :related_user do
      { :votes => 5 }
    end

    # Changes his name by one wider than 4 chars (arbitrary ruby code case)
    # This badge is temporary (user may lose it)
    grant_on 'users#update', :badge => 'autobiographer', :temporary => true do |user|
      user.name.length > 4
    end
  end
end