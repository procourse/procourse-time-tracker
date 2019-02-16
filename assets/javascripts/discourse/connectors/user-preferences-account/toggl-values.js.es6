import { ajax } from "discourse/lib/ajax";
export default {

    shouldRender({ model }, component) {
      return component.siteSettings.time_tracker_enabled;
    },
  
    setupComponent({ model }, component) {
      model.set("custom_fields.toggl_api_key", model.get("toggl_api_key"));
      model.set("custom_fields.toggl_workspaces", parseInt(model.get("toggl_workspaces")));
      if (model.get("toggl_api_key") != "") {
          ajax("/time-tracker/get-workspaces").then((result) => {
	      const workspaces = result.tracker;
	      component.set("workspaces", workspaces);
          });
      } 
      else { component.set("noApiKey", true); }
    }
  
  };
