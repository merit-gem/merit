module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  class Rule
    attr_accessor :badge_name, :level, :to, :temporary, :block

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      # no block given: always true
      no_block_or_true = true
      unless block.nil?
        case block.parameters.count
        when 1
          # block expects parameter: pass target_object
          no_block_or_true = target_obj.nil? ? false : block.call(target_obj)
          # Should warn "no target_obj found"
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
        if applies? action.target_object
          badge.grant_to sash
        elsif temporary?
          badge.delete_from sash
        end
      end
      # Should warn "no sash found"
    end

    # Subject to badge: source_user or target.user?
    def sash_to_badge(action)
      target = case to
               when :action_user
                 User.find_by_id(action.user_id) # _by_id doens't raise ActiveRecord::RecordNotFound
               when :itself
                 action.target_object
               else
                 action.target_object.send(to)
               end
      if target
        target.create_sash_if_none
        target.sash
      end
    end

    # Get rule's related Badge.
    def badge
      badges = Badge.where(:name => badge_name)
      badges = badges.where(:level => level) unless level.nil?
      badges.first
    end
  end
end