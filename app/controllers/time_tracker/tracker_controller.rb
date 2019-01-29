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

    private

    def set_tracker
      raise Discourse::NotAllowed.new if !current_user

      params.require(:topic_id)

      @tracker = Tracker.new(params[:topic_id], current_user.id)
    end

    def get_store
      PluginStore.get("procourse_time_tracker", "active:" + current_user.id.to_s) || []
    end

  end
end
