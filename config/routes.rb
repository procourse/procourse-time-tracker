TimeTracker::Engine.routes.draw {
  post "/start" => "tracker#start"
  post "/stop"  => "tracker#stop"
  post "/edit"  => "tracker#edit"
}

Discourse::Application.routes.append {
  mount TimeTracker::Engine, at: "/time-tracker"
}