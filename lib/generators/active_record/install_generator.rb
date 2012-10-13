require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add active_record merit migrations for the root objects"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations_and_model
        migration_template 'create_merit_actions.rb', 'db/migrate/create_merit_actions.rb'
        migration_template 'create_sashes.rb', 'db/migrate/create_sashes.rb'
        migration_template 'create_badges_sashes.rb', 'db/migrate/create_badges_sashes.rb'
        migration_template 'create_scores_and_points.rb', 'db/migrate/create_scores_and_points.rb'
      end
    end
  end
end
