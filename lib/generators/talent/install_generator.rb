require 'rails/generators/migration'

module Talent
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations_and_model
        migration_template 'create_talent_actions.rb', 'db/migrate/create_talent_actions.rb'
        migration_template 'create_badges.rb', 'db/migrate/create_badges.rb'
        template 'badge.rb', 'app/models/badge.rb'
        template 'talent_rules.rb', 'app/models/talent_rules.rb'
        template 'talent.rb', 'config/initializers/talent.rb'
      end
    end
  end
end
