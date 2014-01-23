module Merit
  # Observers can be registered in initalizer/merit.rb
  # Define observers class or module in an Array as String.
  # The observer must respond to class/module method `process_award(log)`.
  # The argument log is the log record for assigning points or badge
  # config.awarding_observers = ["Foo", "Bar"]
  module Observer
    def notify_observers(action_id, related_change, description = '')
      ActivityLog.create(
        action_id: action_id,
        related_change: related_change,
        description: description
      ).tap do |log|
        send_notification(log) if Merit.awarding_observers.present?
      end
    end

    private

    def send_notification(log)
      Merit.awarding_observers.each do |observer|
        observer = observer.constantize
        observer.send(:process_award, log)
      end
    end

  end
end
