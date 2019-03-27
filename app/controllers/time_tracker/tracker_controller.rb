module TimeTracker
  class TrackerController < ApplicationController

    before_action :set_tracker, except: [:get]

    def start
      response = @tracker.start
      
      if response[:success] == true
        render json: response[:message] || []
      else
        render_json_error(response)        
      end
    end

    def stop
      response = @tracker.stop

      if response[:success] == true
        render json: response[:message] || []
      else
        render_json_error(response)        
      end
    end

    def get
      active_timer = get_store

      # TODO - check Toggl and compare to active_timer, true up
      render json: active_timer || []
    end
    def get_workspaces
      response = @tracker.get_workspaces

      render json: response || []
    end

    private

    def set_tracker
      raise Discourse::InvalidAccess.new if !current_user

      user_id = current_user.id
      user = User.find_by(id: user_id)

      raise Discourse::InvalidParameters.new("missing toggl_api_key") if user.custom_fields["toggl_api_key"].nil? || user.custom_fields["toggl_api_key"] == ""

      @tracker = Tracker.new(params[:topic_id], user_id)
    end

    def get_store
      PluginStore.get("procourse_time_tracker", "active:" + current_user.id.to_s) || []
    end

  end
end
