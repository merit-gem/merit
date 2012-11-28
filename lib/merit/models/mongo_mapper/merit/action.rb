module Merit
  class Action
    include MongoMapper::Document

    key :user_id, String
    key :action_method, String
    key :action_value, Integer
    key :had_errors, Boolean
    key :target_model, String
    key :target_id, String
    key :processed, Boolean, :default => false
    key :log, String
    timestamps!
  end
end
