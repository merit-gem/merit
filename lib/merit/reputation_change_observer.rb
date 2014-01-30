module Merit
  class ReputationChangeObserver
    def update(changed_data)
      ActivityLog.create(
        description:    changed_data[:description],
        related_change: changed_data[:merit_object],
        action_id:      changed_data[:merit_action_id]
      )
    end
  end
end
