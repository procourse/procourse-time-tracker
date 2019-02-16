export default {

    shouldRender({ model }, component) {
      return component.siteSettings.time_tracker_enabled;
    },
  
    setupComponent({ model }, component) {
      model.set("custom_fields.toggl_api_key", model.get("toggl_api_key"));
      model.set("custom_fields.toggl_workspaces", parseInt(model.get("toggl_workspaces")));
      const workspaces = [
        { name: "Test 1", value: 0 },
	{ name: "Test 2", value: 1 }
      ];
      component.set("getWorkspaces", workspaces);
    }
  
  };
