# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered.

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      score 5, :to => :user, :on => [
        'comments#vote'
      ]

      score 20, :on => [
        'comments#create',
        'registrations#update'
      ]
    end
  end
end
