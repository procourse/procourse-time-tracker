# name: procourse-time-tracker
# version: 0.1
# author: ProCourse
# url: https://github.com/procourse/procourse-time-tracker

enabled_site_setting :time_tracker_enabled

register_svg_icon "stop" if respond_to?(:register_svg_icon)
register_svg_icon "clock" if respond_to?(:register_svg_icon)


register_asset "stylesheets/time-tracker.scss"

DiscoursePluginRegistry.serialized_current_user_fields << "toggl_api_key"
DiscoursePluginRegistry.serialized_current_user_fields << "toggl_workspaces"

gem 'awesome_print', '1.8.0'
gem 'logger', '1.3.0'
gem 'togglv8', '1.2.1'
load File.expand_path('../lib/time_tracker/engine.rb', __FILE__)

after_initialize do
  
  Category.register_custom_field_type("enable_time_tracker", :boolean)
  ["enable_time_tracker"].each do |key|
    Site.preloaded_category_custom_fields << key if Site.respond_to? :preloaded_category_custom_fields
    add_to_serializer(:basic_category, key.to_sym) { object.custom_fields[key] }
  end

  class ::Category
    def time_tracker_enabled
      return false unless SiteSetting.time_tracker_enabled

      if self.custom_fields['enable_time_tracker'] != nil
        self.custom_fields['enable_time_tracker']
      end
    end
  end

  # Add to topic model
  require_dependency 'topic'
  class ::Topic
    def can_track_time?
      SiteSetting.time_tracker_enabled && category && category.time_tracker_enabled
    end
  end 
  # Add to topic view serializer
  add_to_serializer(:topic_view, :enable_time_tracker) { object.topic.can_track_time? }

  User.register_custom_field_type("toggl_api_key", :text)
  register_editable_user_custom_field :toggl_api_key

  User.register_custom_field_type("toggl_workspaces", :text)
  register_editable_user_custom_field :toggl_workspaces

  require_dependency "user"
  if SiteSetting.time_tracker_enabled then
    add_to_serializer(:user, :toggl_api_key) {
      if scope.user
        object.custom_fields["toggl_api_key"]
      end
    }
    add_to_serializer(:user, :toggl_workspaces) {
      if scope.user
        object.custom_fields["toggl_workspaces"]
      end
    }
  end
end
