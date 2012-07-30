module Merit
  module Generators
    class UpgradeGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      hook_for :orm
    end
  end
end