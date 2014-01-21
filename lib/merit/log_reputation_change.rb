module Merit
  # TODO: Observer is a misleading name, there's no way to register other
  # observers yet
  class LogReputationChange
    def update(action_id, related_change, description = '')
      ActivityLog.create(
        action_id: action_id,
        related_change: related_change,
        description: description
      )
    end
  end
end
