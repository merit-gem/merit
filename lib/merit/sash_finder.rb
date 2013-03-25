module Merit
  class SashFinder < Struct.new(:rule, :action)
    def self.find(*args)
      TargetFinder.find(*args).try(:_sash)
    end
  end
end
