require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class MeritGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)
      desc "add active_record merit migrations"

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def copy_migrations_and_model
        migration_template "add_fields_to_model.rb", "db/migrate/add_fields_to_#{table_name}"
      end
    end
  end
end
