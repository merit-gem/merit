class Sash
  key :badge_ids, Array
  many :badges, :in => :badge_ids
  timestamps!
end