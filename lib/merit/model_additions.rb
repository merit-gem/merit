module Merit
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def merit(options = {})
      belongs_to :sash
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    # Return it's sash badges
    def badges
      sash.nil? ? [] : sash.badges
    end
  end
end

ActiveRecord::Base.send :include, Merit