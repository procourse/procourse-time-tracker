import { on } from "ember-addons/ember-computed-decorators";
import { ajax } from "discourse/lib/ajax";

export default Ember.Component.extend({

  classNames: ["time-tracker-topic-title"],

  loading: false,

  @on("didInsertElement")
  _setup() {
    this.send("getTimer");
  },

  actions: {

    getTimer() {
      this._ajaxGet("get-timer");
    },

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

    ajax(this._endpoint(path), { type: "POST", data: data }).then(() => {
      debugger;
      this.set("loading", false);
      this.send("getTimer");
    });
  }, 

  _ajaxGet(path) {
    if (this.get("loading")) return;

    this.set("loading", true);

    ajax(this._endpoint(path)).then((result) => {
      if (result.topic_id){
        if (parseInt(result.topic_id) === this.get("model.id")){
          this.set("currentActiveTimer", true);
        }
        else {
          this.set("currentActiveTimer", false);
        }
      }
      else {
        this.set("currentActiveTimer", false);
      }
      this.set("loading", false) 
    });
  }

});
