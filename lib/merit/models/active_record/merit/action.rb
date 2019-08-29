module Merit
  class Action < ActiveRecord::Base
    self.table_name = :merit_actions

    has_many :activity_logs, class_name: 'Merit::ActivityLog'
  end
end
