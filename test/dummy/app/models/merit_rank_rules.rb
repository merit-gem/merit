class MeritRankRules
  include Merit::RankRules

  def initialize
    # i stars for i chars name
    (1..5).each do |i|
      set_rank :stars, :level => i, :to => User do |user|
        user.name.length == i
      end
    end
  end
end