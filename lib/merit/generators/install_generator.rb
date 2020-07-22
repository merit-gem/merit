require "rails/generators"

module Merit
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Copy config and rules files'
      def copy_migrations_and_model
        template 'merit.erb', 'config/initializers/merit.rb'
        template 'merit_badge_rules.erb', 'app/models/merit/badge_rules.rb'
        template 'merit_point_rules.erb', 'app/models/merit/point_rules.rb'
        template 'merit_rank_rules.erb', 'app/models/merit/rank_rules.rb'
      end
    end
  end
end
