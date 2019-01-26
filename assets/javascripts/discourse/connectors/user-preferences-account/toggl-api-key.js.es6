export default {

    shouldRender({ model }, component) {
      return component.siteSettings.time_tracker_enabled;
    },
  
    setupComponent({ model }, _component) {
      model.set("custom_fields.toggl_api_key", model.get("toggl_api_key"));
    }
  
  };