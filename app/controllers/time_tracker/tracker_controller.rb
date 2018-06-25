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

      idx = params[:index]
      data = @tracker.data[idx]

      guardian.ensure_can_edit_timer_data!(data["user_id"])

      ["start", "end"].each do |k|
        if params[k].present?
          data[k] = params[k]
        end
      end

      @tracker.data[idx] = data
      @tracker.save_data

      render_serialized @tracker, TrackerSerializer, root: false, scope: guardian
    end

    private

    def set_tracker
      raise Discourse::NotAllowed.new if !current_user

      params.require(:topic_id)

      @tracker = Tracker.new(params[:topic_id], current_user.id)
      @tracker.guardian = guardian
    end

  end
end
