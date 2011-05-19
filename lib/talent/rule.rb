module Talent
  class Rule
    attr_accessor :badge_name, :level, :to, :block

    # Does this rule pass?
    def applies?(target_obj)
      # no block given: always true
      no_block_or_true = true
      unless self.block.nil?
        # block evaluates to true?
        # FIXME: Are they different objects? http://stackoverflow.com/questions/6002839/initialize-two-variables-on-same-line
        no_block_or_true = called = self.block.call
        if called.kind_of?(Hash)
          # hash methods over target_obj respond what's expected?
          called.each do |method, value|
            no_block_or_true = no_block_or_true && target_obj.send(method) == value
          end
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