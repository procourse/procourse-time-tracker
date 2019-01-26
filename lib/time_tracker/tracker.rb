require 'togglv8'

module TimeTracker
  class Tracker

    attr_reader :user_id, :topic_id
    attr_accessor :guardian

    def initialize(topic_id, user_id = nil)
      @topic_id = topic_id
      @user_id  = user_id
      @user = User.find_by(id: @user_id)
      @api_key = @user.custom_fields['toggl_api_key']
      @topic = Topic.find_by(id: @topic_id)
      @tags = @topic.topic_tags.map {|tag| Tag.find_by(id: tag.tag_id)}
      @toggl_api = TogglV8::API.new(@api_key)
      @toggl_user = @toggl_api.me(all=true)
      @workspaces = @toggl_api.my_workspaces(@toggl_user)
      @workspace_id = @workspaces.first['id']
    end
    
    def start
      begin
        tag_names = @tags.collect { |t| t.name }
        time_entry   = @toggl_api.start_time_entry({
          'description' => "[#{@topic.id}] #{@topic.title}",
          'wid' => @workspace_id,
          'tags' => tag_names,
          'start' => @toggl_api.iso8601((Time.now).to_datetime),
          'created_with' => "ProCourse Time Tracker"
        })
        active_entry = {
          :topic_id => @topic_id,
          :toggl_entry_id => time_entry['id']
        }

        set_store(active_entry)
        
        return {:success => true, :message => {:tracker => active_entry}}
      rescue
        return {:success => false, :message => time_entry}
      end
    end
    
    def stop
      begin
        active_entry = get_store
        stop_entry = @toggl_api.stop_time_entry(active_entry[:toggl_entry_id])
        
        set_store(nil)
        
        return {:success => true, :message => nil}
      rescue
        return {:success => false, :message => stop_entry}
      end
    end

    private

    def get_store
      PluginStore.get("procourse_time_tracker", "active:" + @user_id.to_s) || []
    end

    def set_store(record)
      PluginStore.set("procourse_time_tracker", "active:" + @user_id.to_s, record)
    end

  end
end
