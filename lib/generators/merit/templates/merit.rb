# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongo_mapper and :mongoid
  # config.orm = :active_record

  # Define :user_model_name. This model will be used to grand badge if no :to option is given. Default is "User".
  # config.user_model_name = "User"

  # Define :current_user_method. Similar to previous option. It will be used to retrieve :user_model_name object if no :to option is given. Default is "current_#{user_model_name.downcase}".
  # config.current_user_method = "current_user"

  # Define: use_automatic_after_filter
  # Default is to use automatic after_filter, enabling Merit to log actions behind the scene
  # If disabled, you can call method 'merit_check_and_process' manually in controller,
  # either inside an action say after saving success, or as a custom
  # after_filter like: `after_filter :merit_check_and_process, only: [:create, :update]
  # config.use_automatic_after_filter = true
  
end

# Create application badges (uses https://github.com/norman/ambry)
# Merit::Badge.create!({
#   id: 1,
#   name: 'just-registered'
# }, {
#   id: 2,
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# })
