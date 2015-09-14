module Merit
  class Action
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :activity_logs, class_name: 'Merit::ActivityLog', as: :related_change

    field :user_id
    field :action_method
    field :action_value,            type: Integer
    field :had_errors,              type: Boolean
    field :target_model
    field :target_id
    field :target_data
    field :processed,               type: Boolean, default: false
    field :log
  end
end
