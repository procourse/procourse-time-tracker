module TimeTracker
  class Tracker

    attr_reader :user_id, :topic_id
    attr_accessor :data
    attr_accessor :guardian

    def initialize(topic_id, user_id = nil)
      @topic_id = topic_id
      @user_id  = user_id
      @data     = get(data_key) || []
    end

    def start
      active_topic = get(user_key)

      if !active_topic.blank?
        stop_tracking_topic(active_topic.to_i)
      end

      track_topic
    end

    def stop
      stop_tracking_topic(@topic_id)
    end

    def save_data
      set(data_key, @data)
      publish_update
    end

    def timer
      get(timer_key)
    end

    private

    def track_topic
      set(user_key, @topic_id)
      set(timer_key, Time.now.utc.iso8601)
      publish_update
    end

    def stop_tracking_topic(topic_id)
      set(user_key, nil)

      start_time = get(timer_key(topic_id))

      set(timer_key(topic_id), nil)

      data = get(data_key(topic_id)) || []
      data << { start: start_time, end: Time.now.utc, user_id: @user_id }

      set(data_key, data)
      publish_update
    end

    def get(key)
      PluginStore.get("time_tracker", key)
    end

    def set(key, value)
      PluginStore.set("time_tracker", key, value)
    end

    def user_key
      "user_#{@user_id}"
    end

    def timer_key(topic_id = nil)
      "timer_#{topic_id || @topic_id}"
    end

    def data_key(topic_id = nil)
      "data_#{topic_id || @topic_id}"
    end

    def publish_update
      return if !@guardian

      serialized_data = TrackerSerializer.new(self, root: false, scope: @guardian).as_json

      MessageBus.publish("/time_tracker", { topic_id: @topic_id, data: serialized_data })
    end

  end
end
