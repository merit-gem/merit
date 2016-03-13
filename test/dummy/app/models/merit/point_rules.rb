# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered.

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      # Thanks for voting point. Tests that both rules are called when both
      # apply.
      score 1, on: 'comments#vote'
      score 1, on: 'comments#vote'

      # All user's comments earn points
      score 2, to: :user_comments, on: 'comments#vote'

      # Points to voted user
      score 5, to: :user, on: 'comments#vote', category: 'vote'

      # Example rule for using model_name in the case of namespaced controllers
      score 1, to: :user, model_name: 'Comment', on: 'api/comments#show'

      score 20, on: [
        'comments#create',
        'registrations#update'
      ] do |object|
        if object.class == Comment
          object.name.length > 4
        else
          true
        end
      end

      score lambda { |comment| comment.comment.to_i }, to: :user, on: 'comments#create' do |object|
        object.comment.to_i > 0
      end

      score (-5), to: :user, on: 'comments#destroy' do |comment|
        comment.present?
      end
    end
  end
end
