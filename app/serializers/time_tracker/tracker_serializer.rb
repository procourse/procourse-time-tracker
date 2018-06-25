module TimeTracker
  class TrackerSerializer < ApplicationSerializer

    attributes :can_start_timer, :can_stop_timer, :timer, :timer_data, :users

    def can_start_timer
      scope.can_start_timer?(object.topic_id)
    end

    def can_stop_timer
      scope.can_stop_timer?(object.topic_id)
    end

    def timer
      object.timer
    end

    def timer_data
      # don't make things complicated
      object.data.map do |data|
        TrackerDataSerializer.new(data, root: false, scope: scope)
      end
    end

    def users
      user_ids = object.data.map { |data| data["user_id"] }

      User.where(id: user_ids).all.map do |user|
        BasicUserSerializer.new(user, root: false, scope: scope)
      end
    end

  end
end
