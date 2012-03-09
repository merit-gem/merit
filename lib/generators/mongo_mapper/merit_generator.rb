module MongoMapper
  module Generators
    class MeritGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      desc "add mongo_mapper merit data"

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      def inject_field_types
        inject_into_file model_path, "  # Merit attributes\n  key :sash_id, String\n  key :points, Integer, :default => 0\n", :after => "include MongoMapper::Document\n" if model_exists?
      end
    end
  end
end
