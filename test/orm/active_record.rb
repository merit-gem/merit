# Place orm-dependent test preparation here
migrations = File.expand_path("../../dummy/db/migrate/", __FILE__)

if Rails.version >= "5.2"
  ActiveRecord::MigrationContext.new(migrations).migrate
else
  ActiveRecord::Migrator.migrate migrations
end
