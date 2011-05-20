module Talent
  class Rule
    attr_accessor :badge_name, :level, :to, :block

    # Does this rule pass?
    def applies?(target_obj)
      # no block given: always true
      no_block_or_true = true
      unless self.block.nil?
        called = self.block.call
        if called.kind_of?(TrueClass) || called.kind_of?(FalseClass)
          no_block_or_true = called
        elsif called.kind_of? Hash
          no_block_or_true = called.conditions_apply? target_obj
        end
      end
      no_block_or_true
    end

    # Get rule's related badge.
    def badge
      badges = Badge.where(:name => self.badge_name)
      badges = badges.where(:level => self.level) unless self.level.nil?
      badges.first
    end
  end
end