# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean
# * A block with a hash composed of methods to run on the target object with
#   expected values (+:votes => 5+ for instance).
# 
# +grant_on+ can have a +:to+ option, which can be either +related_user+ or
# +action_user+ (default). The former applies the badge to the target object's
# related user (+post.user+ for instance), while the latter to the user who
# triggered the action (+current_user+, or "source").

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
  end
end