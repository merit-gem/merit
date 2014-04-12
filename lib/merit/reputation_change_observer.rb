module Merit
  class ReputationChangeObserver
    def update(changed_data)
      ActivityLog.create(
        description:    changed_data[:description],
        related_change: related_change(changed_data),
        action_id:      changed_data[:merit_action_id]
      )
    end

    private

    def related_change(data)
      if data[:merit_object].respond_to?(:activity_logs)
        data[:merit_object]
      end
    end
  end
end
