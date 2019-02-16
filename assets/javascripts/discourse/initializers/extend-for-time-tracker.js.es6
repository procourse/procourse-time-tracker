import { withPluginApi } from "discourse/lib/plugin-api";
import PreferencesAccount from "discourse/controllers/preferences/account";
import Topic from "discourse/models/topic";
import { default as computed, observes, on } from 'ember-addons/ember-computed-decorators';
import { h } from "virtual-dom";
import { ajax } from "discourse/lib/ajax";
import hbs from "discourse/widgets/hbs-compiler";

function initWithApi(api) {
  api.createWidget("time-tracker-stop-button", {
    tagName: "div.stop-button",
    template: hbs`
      <form action="/time-tracker/stop" method="post">
        <input type="submit" class="btn-danger"/>
      </form>
    `,
  });
  api.createWidget("time-tracker-control",{
    tagName: "div.time-tracker-controls",
    buildKey: () => "time-tracker-control",

    defaultState() {
      return { items: [], loading: false, loaded: false };
    },

    refreshTimer(state) {
      if (this.loading) return;
      state.loading = true;
      ajax("/time-tracker/get-timer").then((result) => {
      
	if (result.topic_id){
	
          state.items.push(this.attach("link", {
	    href: `/t/${result.topic_id}`,
	    className: "timer-topic-link",
	    icon: "clock",
	  }));
	  state.items.push(this.attach("time-tracker-stop-button"));
	}
      }).finally(() => {
	state.loading = false;
	state.loaded = true;
	this.scheduleRerender();
      });
    },
    html(attrs, state){
      if(!state.loaded) this.refreshTimer(state);
      
      const result = [];
      if (state.items.length) {
        result.push(state.items);
      }
      return result;
    }
  });

//api.decorateWidget("header-icons:before", helper => {
//  return helper.attach("time-tracker-control");
//});
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
