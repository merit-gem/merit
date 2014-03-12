module Merit
  class ReputationChangeObserver
    def update(changed_data)
      # TODO: sometimes we recieved true in changed_data[:merit_object]
      # it should be nil or merit object with activity_logs relation
      ActivityLog.create(
        description:    changed_data[:description],
        related_change: (changed_data[:merit_object] if changed_data[:merit_object].respond_to?(:activity_logs)),
        action_id:      changed_data[:merit_action_id]
      )
    end
  end
end
