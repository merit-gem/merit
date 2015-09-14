module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_id, :badge_name, :level, :to, :model_name, :level_name,
                  :multiple, :temporary, :score, :block, :category

    # Does this rule's condition block apply?
    def applies?(target_obj = nil, current_user = nil)
      return true if block.nil? # no block given: always true
      if target_obj.nil? && current_user.nil?
        Rails.logger.warn '[merit] no target_obj
                          or current_user found on Rule#applies?'
        false
      else
        call_block_with_args target_obj, current_user
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

    private

    def call_block_with_args(target_obj, current_user)
      case block.arity
      when 0
        block.call
      when 1
        block.call(target_obj)
      when 2
        block.call(target_obj, current_user: current_user)
      end
    end
  end
end
