import { withPluginApi } from "discourse/lib/plugin-api";
import PreferencesAccount from "discourse/controllers/preferences/account";

function initWithApi(api) {

  PreferencesAccount.reopen({

    saveAttrNames: ["name", "title", "custom_fields"],

    setTogglAPIKeyFor(obj) {
      obj.set("toggl_api_key", this.get("model.custom_fields.toggl_api_key"));
    },

    _updateEthereumAddress: function() {
      if (!this.siteSettings.time_tracker_enabled) return;

      if (this.get("saved")) {
        this.setTogglAPIKeyFor(this.get("model"));
      }
    }.observes("saved")

  });
}

export default {
  name: "extend-for-time-tracker",
  initialize() { withPluginApi("0.1", initWithApi); }
};