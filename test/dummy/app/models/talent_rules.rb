class TalentRules
  include Talent::Rules

  def initialize(user)
    user ||= User.new

    grant_on 'users#create', :badge => 'just', :level => 'registered' do
      true
    end

    grant_on 'comments#create', :badge => 'commenter', :level => 10 do
      user.comments.count == 10
    end

    check_new_actions # FIXME: Should be called somewhere else?
  end
end