import { on } from "ember-addons/ember-computed-decorators";
import { ajax } from "discourse/lib/ajax";

export default Ember.Component.extend({

  classNames: ["time-tracker-topic-title"],

  loading: false,

  @on("didInsertElement")
  _setup() {
    this.messageBus.subscribe("/time_tracker", (result) => {
      if (result.topic_id == this.get("model.id")) {
        this.set("model.time_tracker", result.data);
      }
    });
  },

  @on("willDestroyElement")
  _unsubscribe() {
    this.messageBus.unsubscribe("/time_tracker");
  },

  actions: {

    start() {
      this._ajax("start", { topic_id: this.get("model.id") });
    },

    stop() {
      this._ajax("stop", { topic_id: this.get("model.id") });
    }

  },

  _endpoint(path) {
    return `/time-tracker/${path}`;
  },

  _ajax(path, data) {
    if (this.get("loading")) return;

    this.set("loading", true);

    ajax(this._endpoint(path), { type: "POST", data: data }).finally( () => this.set("loading", false) );
  }

});
