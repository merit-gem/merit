require 'observer'

module Merit
  class Judge
    include Observable

    def initialize(sashes, rule, options = {})
      @sashes = sashes
      @rule = rule
      # FIXME: Too much context?
      # A Judge should apply reputation independently of the action
      @action = options[:action]
    end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def apply_badges
      if rule_applies?
        grant_badges
      else
        remove_badges if @rule.temporary
      end
    end

    def apply_points
      return unless rule_applies?
      @sashes.each do |sash|
        point = sash.add_points points
        notify_observers @action.id, point
      end
    end

    private

    def grant_badges
      @sashes.each do |sash|
        next unless new_or_multiple?(sash)
        badge_sash = sash.add_badge badge.id
        notify_observers @action.id, badge_sash, 'granted'
      end
    end

    def remove_badges
      @sashes.each do |sash|
        badge_sash = sash.rm_badge badge.id
        notify_observers @action.id, badge_sash, 'removed'
      end
    end

    def new_or_multiple?(sash)
      !sash.badge_ids.include?(badge.id) || @rule.multiple
    end

    def rule_object
      BaseTargetFinder.find(@rule, @action)
    end

    def rule_applies?
      @rule.applies? rule_object
    end

    def points
      if @rule.score.respond_to?(:call)
        @rule.score.call(rule_object)
      else
        @rule.score
      end
    end

    def badge
      @rule.badge
    end

    def notify_observers(action_id, related_change, description = '')
      changed
      super
    end
  end
end
