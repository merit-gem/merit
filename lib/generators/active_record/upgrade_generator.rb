require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class UpgradeGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add active_record merit migrations"

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      end

      def copy_migrations_and_model
        migration_template 'add_id_to_badges_sashes.rb', 'db/migrate/add_id_to_badges_sashes.rb'
      end
    end
  end
end
