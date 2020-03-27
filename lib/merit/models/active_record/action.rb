module Merit::Models::ActiveRecord
  class Action < ActiveRecord::Base
    include Merit::Models::ActionConcern

    self.table_name = :merit_actions

    has_many :activity_logs, class_name: 'Merit::ActivityLog'
  end
end

class Merit::Action < Merit::Models::ActiveRecord::Action; end
