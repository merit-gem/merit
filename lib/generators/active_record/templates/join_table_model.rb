class Badges<%= file_path.camelize %> < ActiveRecord::Base
  belongs_to :badge
  belongs_to :<%= file_path %>
end