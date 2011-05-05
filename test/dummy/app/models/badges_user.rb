class BadgesUser < ActiveRecord::Base
  belongs_to :badge
  belongs_to :user
end