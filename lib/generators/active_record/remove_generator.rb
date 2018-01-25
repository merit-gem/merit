require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class RemoveGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)
      desc 'Creates a migration file to remove all traces of Merit on the DB'

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def copy_migrations_and_model
        migration_template 'remove_merit_tables.rb',
                           'db/migrate/remove_merit_tables.rb'

        migration_template(
          'remove_merit_fields_from_model.rb',
          "db/migrate/remove_merit_fields_from_#{table_name}.rb"
        )
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
