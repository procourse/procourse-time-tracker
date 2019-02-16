import { withPluginApi } from "discourse/lib/plugin-api";
import PreferencesAccount from "discourse/controllers/preferences/account";
import computed from "ember-addons/ember-computed-decorators";
import { observes } from "ember-addons/ember-computed-decorators";

function initWithApi(api) {
    PreferencesAccount.reopen({
        saveAttrNames: ["name", "title", "custom_fields"],
	setTogglValues(obj) {
          obj.set("toggl_api_key", this.get("model.custom_fields.toggl_api_key"));
          obj.set("toggl_workspaces", this.get("model.custom_fields.toggl_workspaces"));
        },

	_updateTogglValues: function() {
	    if (!this.siteSettings.time_tracker_enabled) return;
            if (this.get("saved")) {
	        this.setTogglValues(this.get("model"));
	    }
	}.observes("saved")
    });
}

export default {
  name: "extend-for-time-tracker",
  initialize() { withPluginApi("0.1", initWithApi); }
};
