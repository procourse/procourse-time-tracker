module TimeTracker
  class TrackerSerializer < ApplicationSerializer

    attributes :start, :end, :user_id, :can_edit

    def start
      object["start"]
    end

    def end
      object["end"]
    end

    def user_id
      object["user_id"]
    end

    def can_edit
      scope.can_edit_timer_data?(user_id)
    end

  end
end