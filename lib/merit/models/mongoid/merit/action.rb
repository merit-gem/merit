module Merit
  class Action
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user
    field :action_method
    field :action_value, :type => Integer
    field :had_errors, :type => Boolean

    belongs_to :target, :polymorphic => true
    field :processed, :type => Boolean, :default => false
    field :log
  end
end
