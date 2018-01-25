require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class UpgradeGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)
      desc 'Makes Active Record migrations to handle upgrades between versions'

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def copy_migrations_and_model
        if merit_actions_exists? && target_data_column_doesnt_exist?
          migration_template 'add_target_data_to_merit_actions.rb',
                             'db/migrate/add_target_data_to_merit_actions.rb'
        end
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end

      private

      def target_data_column_doesnt_exist?
        !ActiveRecord::Base.connection.column_exists?(:merit_actions,
                                                      :target_data)
      end

      # Might be foolishly running this before install. Ugly error if we don't
      # check.
      def merit_actions_exists?
        ActiveRecord::Base.connection.table_exists? :merit_actions
      end
    end
  end
end
