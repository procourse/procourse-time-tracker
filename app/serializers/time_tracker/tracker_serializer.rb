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
      ActiveModel::ArraySerializer.new(object.data, each_serializer: TrackerDataSerializer).as_json
    end

    def users
      user_ids = object.data.map { |data| data["user_id"] }
      ActiveModel::ArraySerializer.new(User.where(id: user_ids), each_serializer: BasicUserSerializer).as_json
    end

  end
end