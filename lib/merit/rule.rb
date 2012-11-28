module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_name, :level, :to, :model_name, :level_name,
      :multiple, :temporary, :score, :block

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      return true if block.nil? # no block given: always true

      case block.arity
      when 1 # Expects target object
        if target_obj.present?
          block.call(target_obj)
        else
          # TODO RAISE ERROR
          Rails.logger.warn "[merit] no target_obj found on Rule#applies?"
          false
        end
      else # evaluates to boolean. block.arity returns 0 in Ruby 1.9.3 and -1 in Ruby 1.8.7
        block.call
      end
    end

    def temporary?; self.temporary; end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def grant_or_delete_badge(action)
      unless (sash = sash_to_badge(action))
        Rails.logger.warn "[merit] no sash found on Rule#grant_or_delete_badge for action #{action.inspect}"
        return
      end

      if applies? action.target_object(model_name)
        if badge.grant_to(sash, :allow_multiple => self.multiple)
          to_action_user = (to.to_sym == :action_user ? '_to_action_user' : '')
          action.log!("badge_granted#{to_action_user}:#{badge.id}")
        end
      elsif temporary?
        if badge.delete_from(sash)
          action.log!("badge_removed:#{badge.id}")
        end
      end
    end

    def grant_points(action)
      unless (sash = sash_to_badge(action))
        Rails.logger.warn "[merit] no sash found on Rule#grant_points"
        return
      end

      if applies? action.target_object(model_name)
        sash.add_points self.score, action.inspect[0..240]
        action.log!("points_granted:#{self.score}")
      end
    end

    # Subject to badge: source_user or target.user?
    # Knows (law of demeter):
    #  * Rule#model_name & Rule#to
    #  * MeritAction#object & MeritAction#target_object
    def sash_to_badge(action)
      if to == :itself
        target = action.target_object(model_name)
      else
        target = action.target(to)
      end
      target._sash if target
    end

    # Get rule's related Badge.
    def badge
      if @badge.nil?
        badges = Badge.by_name(badge_name)
        badges = badges.by_level(level) unless level.nil?
        if !(@badge = badges.first)
          raise BadgeNotFound, "No badge '#{badge_name}'#{level.nil? ? '' : " with level #level"} found. Define it in 'config/initializers/merit.rb'."
        end
      end
      @badge
    end
  end
end
