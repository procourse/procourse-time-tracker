class Guardian

  def can_start_timer?(topic_id)
    return false if !SiteSetting.time_tracker_enabled

    tt_topic ||= Topic.includes(:category).where(id: topic_id).first

    return false if !tt_topic
    return false if !can_see_topic?(tt_topic)
    return false if !tt_topic.category

    return tt_topic.category.custom_fields["enable_time_tracker"]
  end

  def can_stop_timer?(topic_id)
    return false if !authenticated?

    saved_user = PluginStoreRow.where(plugin_name: "time_tracker").where("key LIKE 'user_%'").where(value: topic_id.to_s).first

    return false if !saved_user

    return saved_user.key.split("_")[1].to_i == user.id
  end

  def can_edit_timer_data?(user_id)
    return dalse if !authenticated

    return true if is_staff? 

    return user_id == user.id
  end

end