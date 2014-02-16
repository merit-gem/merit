require 'observer'

module Merit
  class Judge
    include Observable

    def initialize(rule, options = {})
      @rule = rule
      @action = options[:action]
      Merit.observers.each do |class_name|
        add_observer class_name.constantize.new
      end
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
      sashes.each do |sash|
        point = sash.add_points points, 'Manually granted', category
        notify_observers(
          description: "granted #{points} points",
          merit_object: point,
          merit_action_id: @action.id
        )
      end
    end

    private

    def grant_badges
      sashes.each do |sash|
        next unless new_or_multiple?(sash)
        badge_sash = sash.add_badge badge.id
        notify_observers(
          description: "granted #{badge.name} badge",
          merit_object: badge_sash,
          merit_action_id: @action.id
        )
      end
    end

    def remove_badges
      sashes.each do |sash|
        badge_sash = sash.rm_badge badge.id
        notify_observers(
          description: "removed #{badge.name} badge",
          merit_object: badge_sash,
          merit_action_id: @action.id
        )
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
    
    def category
      @rule.category
    end

    def sashes
      @sashes ||= SashFinder.find @rule, @action
    end

    def badge
      @rule.badge
    end

    def notify_observers(changed_data)
      changed
      super
    end
  end
end
