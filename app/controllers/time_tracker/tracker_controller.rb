module TimeTracker
  class TrackerController < ApplicationController

    before_action :set_tracker

    def start
      guardian.ensure_can_start_timer!(@tracker.topic_id)

      @tracker.start

      render json: success_json
    end

    def stop
      guardian.ensure_can_stop_timer!(@tracker.topic_id)

      @tracker.stop

      render json: success_json
    end

    def edit
      params.require(:index)

      timer_data = @tracker.data[params[:index]]
      guardian.ensure_can_edit_timer_data!(timer_data["user_id"])

      ["start", "end"].each do |k|
        if params[k].present?
          timer_data[k] = params[k]
        end
      end

      @tracker.data[params[:index]] = timer_data
      @tracker.save_data

      render_serialized @tracker, TrackerSerializer, root: false, scope: guardian
    end

    private

    def set_tracker
      raise Discourse::NotAllowed.new if !current_user

      params.require(:topic_id)

      @tracker = Tracker.new(@topic_id, current_user.id)
    end

  end
end