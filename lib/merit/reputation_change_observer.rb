module Merit
  class ReputationChangeObserver
    def update(action_id, related_change, description = '')
      ActivityLog.create(
        action_id: action_id,
        related_change: related_change,
        description: description
      )
    end
  end
end
