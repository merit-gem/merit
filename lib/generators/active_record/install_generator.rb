require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)
      desc 'add active_record merit migrations for the root objects'

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def copy_migrations_and_model
        migration_template 'create_merit_actions.rb',
                           'db/migrate/create_merit_actions.rb'

        migration_template 'create_merit_activity_logs.rb',
                           'db/migrate/create_merit_activity_logs.rb'

        migration_template 'create_sashes.rb',
                           'db/migrate/create_sashes.rb'

        migration_template 'create_badges_sashes.rb',
                           'db/migrate/create_badges_sashes.rb'

        migration_template 'create_scores_and_points.rb',
                           'db/migrate/create_scores_and_points.rb'
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
