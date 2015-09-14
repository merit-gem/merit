module Merit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      hook_for :orm

      desc 'Copy config and rules files'
      def copy_migrations_and_model
        template 'merit.rb', 'config/initializers/merit.rb'
        template 'merit_badge_rules.rb', 'app/models/merit/badge_rules.rb'
        template 'merit_point_rules.rb', 'app/models/merit/point_rules.rb'
        template 'merit_rank_rules.rb', 'app/models/merit/rank_rules.rb'
      end
    end
  end
end
