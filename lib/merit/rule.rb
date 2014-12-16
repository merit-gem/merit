module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_id, :badge_name, :level, :to, :model_name, :level_name,
                  :multiple, :temporary, :score, :block, :category

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      return true if block.nil? # no block given: always true

      case block.arity
      when 1 # Expects target object
        if target_obj.present?
          block.call(target_obj)
        else
          Rails.logger.warn '[merit] no target_obj found on Rule#applies?'
          false
        end
      when 0
        block.call
      end
    end

    # Get rule's related Badge.
    def badge
      if badge_id
        Merit::Badge.find(badge_id)
      else
        Merit::Badge.find_by_name_and_level(badge_name, level)
      end
    end
  end
end
