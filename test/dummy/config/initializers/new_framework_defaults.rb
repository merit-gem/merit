if Rails.version >= "5.1"
  Rails.application.config.active_record.belongs_to_required_by_default = true
end
