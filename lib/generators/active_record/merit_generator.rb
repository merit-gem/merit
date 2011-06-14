require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class MeritGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      source_root File.expand_path("../templates", __FILE__)

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      def copy_merit_migration
        migration_template "add_sash_id_to_model.rb", "db/migrate/add_sash_id_to_#{table_name}"
      end
    end
  end
end
