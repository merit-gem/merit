# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit_point_rules.rb+. They are given on
# actions-triggered.

class MeritPointRules
  include Merit::PointRules

  def initialize
    # give 10.points, :on => [
    #   'users#update'
    # ]
    #
    # give 20.points, :on => [
    #   'comments#create',
    #   'photos#create'
    # ]
  end
end