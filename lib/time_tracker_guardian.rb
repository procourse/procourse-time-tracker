module TimeTrackerGuardian

  def can_start_timer?(topic_id)
    return false if !SiteSetting.time_tracker_enabled
    
    topic = Topic.includes(:category).where(id: topic_id).first

    return false if ( !topic || !can_see_topic?(topic) || !topic.category || topic.private_message? )

    topic.category.custom_fields["enable_time_tracker"]
  end

  def can_stop_timer?(topic_id)
    return false if !authenticated?
    
    topic = Topic.includes(:category).where(id: topic_id).first

    return false if ( !topic || !can_see_topic?(topic) || !topic.category || topic.private_message? )

    topic.category.custom_fields["enable_time_tracker"]
  end

end
