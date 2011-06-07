module Talent
  class Rule
    attr_accessor :badge_name, :level, :to, :temporary, :block

    # Does this rule apply?
    def applies?(target_obj = nil)
      # no block given: always true
      no_block_or_true = true
      unless block.nil?
        if block.parameters.count == 1
          # block expects parameter: pass target_object
          no_block_or_true = block.call(target_obj)
        elsif block.parameters.count == 0
          # block evaluates to true, or is a hash of methods and expected value
          called = block.call
          if called.kind_of?(Hash)
            no_block_or_true = called.conditions_apply? target_obj
          end
        end
      end
      no_block_or_true
    end

    # Is this rule's badge temporary?
    def temporary?
      self.temporary
    end

    # Get rule's related Badge.
    def badge
      badges = Badge.where(:name => badge_name)
      badges = badges.where(:level => level) unless level.nil?
      badges.first
    end
  end
end