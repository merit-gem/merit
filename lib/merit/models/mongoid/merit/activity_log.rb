module Merit
  class ActivityLog
    include Mongoid::Document
    include Mongoid::Timestamps

    field :related_change
    field :description

    belongs_to :action, class_name: 'Merit::Action'
    belongs_to :related_change, polymorphic: true
  end
end
