import { default as computed, on } from "ember-addons/ember-computed-decorators";

export default Ember.Component.extend({

  classNames: ["timer"],

  hours: 0,
  minutes: 0,
  seconds: 0,

  @on("didInsertElement")
  _setup() {
    this._updateTimer();
    const updater = setInterval(() => {
      this._updateTimer();
    }, 1000);
    this.set("updater", updater);
  },

  @on("willDestroyElement")
  _stopUpdater() {
    const updater = this.get("updater");
    if (updater) clearInterval(updater);
  },

  _updateTimer() {
    const now       = moment(new Date());
    const start     = moment(this.get("time"));
    const duration  = moment.duration(now.diff(start));

    this.setProperties({
      hours: parseInt(duration.asHours()),
      minutes: duration.minutes(),
      seconds: duration.seconds()
    });
  },

  @computed("hours", "minutes", "seconds")
  formattedTime(hours, minutes, seconds) {
    let result = "";

    result += `<span class="tt-num hours">${this._addZero(hours)}</span>`;
    result += "<span class=\"tt-sep\">:</span>";
    result += `<span class="tt-num minutes">${this._addZero(minutes)}</span>`;
    result += "<span class=\"tt-sep\">:</span>";
    result += `<span class="tt-num seconds">${this._addZero(seconds)}</span>`;

    return result;
  },

  _addZero(num) {
    return num > 9 ? num : "0" + num;
  }

});
