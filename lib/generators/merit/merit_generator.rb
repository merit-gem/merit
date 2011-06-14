module Merit
  module Generators
    class MeritGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      hook_for :orm
    end
  end
end