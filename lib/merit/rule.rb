module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  class Rule
    attr_accessor :badge_name, :level, :to, :temporary, :block, :model_name

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      # no block given: always true
      no_block_or_true = true
      unless block.nil?
        case block.parameters.count
        when 1
          # block expects parameter: pass target_object
          if target_obj.nil?
            no_block_or_true = false
            Rails.logger.warn "[merit] no target_obj found on Rule#applies?"
          else
            no_block_or_true = block.call(target_obj)
          end

        when 0
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
    def temporary?; self.temporary; end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def grant_or_delete_badge(action)
      if sash = sash_to_badge(action)
        if applies? action.target_object(model_name)
          badge.grant_to sash
        elsif temporary?
          badge.delete_from sash
        end
      else
        Rails.logger.warn "[merit] no sash found on Rule#grant_or_delete_badge"
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
                 rescue
                   Rails.logger.warn "[merit] #{action.target_model.singularize}.find(#{action.target_id}) not found, no badges giving today"
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
        @badge = badges.first
      end
      @badge
    end
  end
end
