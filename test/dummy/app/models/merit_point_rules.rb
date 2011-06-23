# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit_point_rules.rb+. They are given on
# actions-triggered.

class MeritPointRules
  include Merit::PointRules

  def initialize
    score 5, :on => [
      'comments#vote'
    ]

    score 20, :on => [
      'comments#create',
      'users#update'
    ]
  end
end