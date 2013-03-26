module Merit
  class BadgeJudge

    def self.judge(*args)
      self.new(*args).judge
    end

    def initialize(sash, rule, action)
      @sash = sash
      @rule = rule
      @action = action
    end

    def judge
      if rule_applies?
        award_badge if sash_can_get_badge?
      else
        remove_badge
      end
    end

    private

    def award_badge
      BadgeAwarder.award @sash, @rule, @action
    end

    def remove_badge
      BadgeRevoker.revoke @sash, badge, @action
    end

    def sash_can_get_badge?
      !@sash.badge_ids.include?(badge.id) || @rule.multiple
    end

    def rule_applies?
      @rule.applies? target
    end

    def target
      @target ||= BaseTargetFinder.find(@rule, @action)
    end

    def badge
      @rule.badge
    end

  end
end
