class TalentRules
  include Talent::Rules

  def initialize(user)
    user ||= User.new

    # If it creates user, grant badge
    # grant_on 'users#create', :badge => 'just', :level => 'registered'

    # If it has 10 comments, grant commenter-10 badge
    # grant_on 'comments#create', :badge => 'commenter', :level => 10 do
    #   user.comments.count == 10
    # end

    # If it has 20 comments, grant commenter-20 badge
    # grant_on 'comments#create', :badge => 'commenter', :level => 20 do
    #   user.comments.count == 20
    # end

    check_new_actions # FIXME: Should be called somewhere else?
  end
end