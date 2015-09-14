# Place orm-dependent test preparation here
ActiveRecord::Migrator.migrate File.expand_path("../../dummy/db/migrate/", __FILE__)