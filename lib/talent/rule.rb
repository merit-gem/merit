module Talent
  class Rule
    attr_accessor :badge_name, :level, :to, :block

    # Does this rule apply?
    def applies?(target_obj)
      # no block given: always true
      no_block_or_true = true
      unless self.block.nil?
        if self.block.parameters.count == 1
          # block expects parameter: pass target_object
          no_block_or_true = self.block.call(target_obj)
        elsif self.block.parameters.count == 0
          # block evaluates to true, or is a hash of methods and expected value
          # TODO: Do we need a block with no parameters? Would be cached (predefined) on production!
          called = self.block.call
          if called.kind_of?(TrueClass) || called.kind_of?(FalseClass)
            no_block_or_true = called
          elsif called.kind_of?(Hash)
            no_block_or_true = called.conditions_apply? target_obj
          end
        end
      end
      no_block_or_true
    end

    # Get rule's related Badge.
    def badge
      badges = Badge.where(:name => self.badge_name)
      badges = badges.where(:level => self.level) unless self.level.nil?
      badges.first
    end
  end
end