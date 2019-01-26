module TimeTracker
  class Engine < ::Rails::Engine
    isolate_namespace TimeTracker

    config.after_initialize do
  		Discourse::Application.routes.append do
        mount ::TimeTracker::Engine, at: "/time-tracker"
      end
    end
  end
end
require_relative "../../lib/time_tracker/tracker"
