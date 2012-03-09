class MeritAction
  key :user_id, String
  key :action_method, String
  key :action_value, Integer
  key :had_errors, Boolean
  key :target_model, String
  key :target_id, Integer
  key :processed, Boolean, :default => false
  timestamps!
end