module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_name, :level, :to, :multiple, :temporary, :block, :model_name, :level_name

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      return true if block.nil? # no block given: always true

      case block.arity
      when 1 # Expects target object
        if target_obj.present?
          return block.call(target_obj)
        else
          Rails.logger.warn "[merit] no target_obj found on Rule#applies?. MeritAction: #{action.inspect}"
          return false
        end
      else # evaluates to boolean. block.arity returns 0 in Ruby 1.9.3 and -1 in Ruby 1.8.7
        return block.call
      end
    end

    def multiple?; self.multiple; end
    def temporary?; self.temporary; end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def grant_or_delete_badge(action)
      unless (sash = sash_to_badge(action))
        Rails.logger.warn "[merit] no sash found on Rule#grant_or_delete_badge"
        return
      end

      if applies? action.target_object(model_name)
        if !sash.badge_ids.include?(badge.id) || multiple?
          badge.grant_to(sash)
          to_action_user = (to.to_sym == :action_user ? '_to_action_user' : '')
          action.log!("badge_granted#{to_action_user}:#{badge.id}")
        end
      elsif temporary?
        if badge.delete_from(sash)
          action.log!("badge_removed:#{badge.id}")
        end
      end
    end

    # Subject to badge: source_user or target.user?
    def sash_to_badge(action)
      target = case to
               when :action_user
                 User.find_by_id(action.user_id) # _by_id doens't raise ActiveRecord::RecordNotFound
               when :itself
                 action.target_object(model_name)
               else
                 begin
                   action.target_object(model_name).send(to)
                 rescue NoMethodError
                   Rails.logger.warn "[merit] #{action.target_model.singularize.camelize}.find(#{action.target_id}) not found, no badges giving today"
                   return
                 end
               end
      if target
        target.create_sash_if_none
        target.sash
      end
    end

    # Get rule's related Badge.
    def badge
      if @badge.nil?
        badges = Badge.by_name(badge_name)
        badges = badges.by_level(level) unless level.nil?
        if !(@badge = badges.first)
          raise "No badge '#{badge_name}'#{level.nil? ? '' : " with level #level"} found. Define it in 'config/initializers/merit.rb'."
        end
      end
      @badge
    end
  end
end
