# name: procourse-time-tracker
# version: 0.1
# author: Muhlis Budi Cahyono
# url: https://github.com/procourse/procourse-time-tracker

enabled_site_setting :time_tracker_enabled

after_initialize {

  Category.register_custom_field_type("enable_time_tracker", :boolean)

}