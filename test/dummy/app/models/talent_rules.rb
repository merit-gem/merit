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

    check_last_actions # FIXME: Should be called every 5 mins or every action, but not from here.
  end
end