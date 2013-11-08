# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # Example rule with block with no parameters
      grant_on 'users#create', badge: 'just-registered', to: :itself do
        true
      end

      # Example rule for multiple badge granting
      grant_on 'users#index', badge: 'gossip', multiple: true

      # Example rule for badge granting in namespaced controllers
      grant_on 'admin/users#index', badge: 'visited_admin'

      # Example rule for testing badge granting in differently namespaced controllers.
      grant_on '.*users#index', badge: 'wildcard_badge', multiple: true

      grant_on 'comments#vote', badge: 'only_certain_users' do |_, current_user|
        current_user.name == 'Grant only me'
      end

      # If it has 10 comments, grant commenter-10 badge
      grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
        comment.user.comments.count >= 10
      end
      # Testing badge granting in more than one rule per action with different targets
      grant_on 'comments#create', badge: 'has_commenter_friend', to: :friend do |comment|
        comment.user.comments.count >= 10
      end

      # If it has at least 10 votes, grant relevant-commenter badge
      grant_on 'comments#vote', badge: 'relevant-commenter', to: :user do |comment|
        comment.votes >= 10
      end

      # Changes his name by one wider than 4 chars (arbitrary ruby code and custom model_name)
      # This badge is temporary (user may lose it)
      grant_on 'registrations#update', badge: 'autobiographer', temporary: true, model_name: 'User' do |user|
        user.name.length > 4
      end
    end
  end
end
