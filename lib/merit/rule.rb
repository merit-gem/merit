module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_name, :level, :to, :model_name, :level_name,
      :multiple, :temporary, :score, :block

    # Does this rule's condition block apply?
    def applies?(target_obj = nil, current_user = nil)
      return true if block.nil? # no block given: always true
      if block.arity == 0
        block.call
      else
        # NOTE: For index actions, where there's no target_obj, it may make
        # sense to grant reputation based only on current_user? That case is
        # not allowed with this conditional. API feels still weird.
        if target_obj.present?
          call_block_with_args(target_obj, current_user)
        else
          Rails.logger.warn '[merit] no target_obj found on Rule#applies?'
          false
        end
      end
    end

    # Get rule's related Badge.
    def badge
      @badge ||= Badge.find_by_name_and_level(badge_name, level)
    end

    private

    def call_block_with_args(target_obj, current_user)
      if block.arity == 1
        block.call(target_obj)
      elsif block.arity == 2
        if current_user.present?
          block.call(target_obj, current_user)
        else
          Rails.logger.warn '[merit] no current_user found on Rule#applies?'
          false
        end
      end
    end

  end
end
