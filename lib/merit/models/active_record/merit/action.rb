module Merit
  class Action < ActiveRecord::Base
    self.table_name = :merit_actions

    has_many :activity_logs, class_name: Merit::ActivityLog

    attr_accessible :user_id, :action_method, :action_value, :had_errors,
      :target_model, :target_id, :processed, :log
  end
end
