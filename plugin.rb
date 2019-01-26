# name: procourse-time-tracker
# version: 0.1
# author: ProCourse
# url: https://github.com/procourse/procourse-time-tracker

enabled_site_setting :time_tracker_enabled

register_svg_icon "stop" if respond_to?(:register_svg_icon)

register_asset "stylesheets/time-tracker.scss"

require_relative "lib/guardian"

gem 'awesome_print', '1.8.0'
gem 'logger', '1.3.0'
gem 'togglv8', '1.2.1'
load File.expand_path('../lib/time_tracker/engine.rb', __FILE__)

after_initialize {


  Category.register_custom_field_type("enable_time_tracker", :boolean)

  # add_to_serializer(:topic_view, :time_tracker, false) {

  #   tracker = TimeTracker::Tracker.new(id)
  #   TimeTracker::TrackerSerializer.new(tracker, root: false, scope: scope).as_json

  # }
}
