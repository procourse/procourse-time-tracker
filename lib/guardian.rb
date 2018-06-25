class Guardian

  def can_start_timer?(topic_id)
    return false if !SiteSetting.time_tracker_enabled

    topic = Topic.includes(:category).where(id: topic_id).first

    return false if ( !topic || !can_see_topic?(topic) || !topic.category || topic.private_message? )

    topic.category.custom_fields["enable_time_tracker"]
  end

  def can_stop_timer?(topic_id)
    return false if !authenticated?

    saved_user = PluginStoreRow.where(plugin_name: "time_tracker").where("key LIKE 'user_%'").where(value: topic_id.to_s).first

    return false if !saved_user

    saved_user.key.split("_")[1].to_i == user.id
  end

  def can_edit_timer_data?(user_id)
    return false if !authenticated?

    return true if is_staff? 

    user_id == user.id
  end

end
