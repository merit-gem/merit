module Merit
  class ActivityLog < ActiveRecord::Base
    self.table_name = :merit_activity_logs

    belongs_to :action, class_name: Merit::Action
    belongs_to :related_change, polymorphic: true

    if defined?(ProtectedAttributes) || !defined?(ActionController::StrongParameters)
      attr_accessible :action_id, :related_change, :description, :created_at
    end
  end
end
