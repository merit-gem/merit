module Merit
  module Generators
    class UpgradeGenerator < Rails::Generators::Base
      hook_for :orm
    end
  end
end
