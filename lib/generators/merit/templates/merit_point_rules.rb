# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit_point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      # score 10, :on => [
      #   'users#update'
      # ]
      #
      # score 15, :on => 'reviews#create', :to => [:reviewer, :reviewed]
      #
      # score 20, :on => [
      #   'comments#create',
      #   'photos#create'
      # ]
    end
  end
end
