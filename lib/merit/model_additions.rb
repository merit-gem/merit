module Merit
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_merit(options = {})
      belongs_to :sash
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    # Return it's sash badges
    def badges
      create_sash_if_none
      sash.badges
    end

    # Create sash if doesn't have
    def create_sash_if_none
      if sash.nil?
        self.sash = Sash.new
        self.save(:validate => false)
      end
    end
  end
end

ActiveRecord::Base.send :include, Merit