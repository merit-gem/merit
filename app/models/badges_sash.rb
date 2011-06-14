class BadgesSash < ActiveRecord::Base
  belongs_to :badge
  belongs_to :sash
end