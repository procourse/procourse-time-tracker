TimeTracker::Engine.routes.draw do
  post "/start" => "tracker#start"
  post "/stop"  => "tracker#stop"
  get "/get-timer"  => "tracker#get"
  get "/get-workspaces"  => "tracker#get_workspaces"
end
