# name: procourse-time-tracker
# version: 0.1
# author: Muhlis Budi Cahyono
# url: https://github.com/procourse/procourse-time-tracker

enabled_site_setting :time_tracker_enabled

register_asset "stylesheets/time-tracker.scss"

require_relative "lib/time_tracker"
require_relative "lib/guardian"

after_initialize {

  Category.register_custom_field_type("enable_time_tracker", :boolean)

  add_to_serializer(:topic_view, :time_tracker, false) {

    tracker = TimeTracker::Tracker.new(id)
    TimeTracker::TrackerSerializer.new(tracker, root: false, scope: scope).as_json

  }

}
