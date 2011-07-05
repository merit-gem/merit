# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit_point_rules.rb+. They are given on
# actions-triggered.

class MeritPointRules
  include Merit::PointRules

  def initialize
    # score 10, :on => [
    #   'users#update'
    # ]
    #
    # score 20, :on => [
    #   'comments#create',
    #   'photos#create'
    # ]
  end
end