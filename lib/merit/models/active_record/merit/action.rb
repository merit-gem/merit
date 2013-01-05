module Merit
  class Action < ActiveRecord::Base
    self.table_name = :merit_actions

    attr_accessible :user_id, :action_method, :action_value, :had_errors,
      :target_model, :target_id, :processed, :log
  end
end
