require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class TalentGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      source_root File.expand_path("../templates", __FILE__)

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      def generate_model
        template 'join_table_model.rb', File.join('app/models', "badges_#{file_name}.rb")
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

      def copy_talent_migration
        migration_template "join_table_migration.rb", "db/migrate/talent_create_badges_#{table_name}"
      end

      def inject_talent_content
        inject_into_class(model_path, class_name, <<CONTENT) if model_exists?
  has_many :badges_#{table_name}
  has_many :badges, :through => :badges_#{table_name}

CONTENT
        inject_into_class(File.join("app", "models", "badge.rb"), 'Badge', <<CONTENT) if model_exists?
  has_many :badges_#{table_name}
  has_many :#{table_name}, :through => :badges_#{table_name}
CONTENT
      end
    end
  end
end
