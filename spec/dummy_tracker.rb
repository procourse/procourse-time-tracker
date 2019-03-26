RSpec.shared_context "dummy tracker" do
  before(:each) do
    module ::TimeTracker
      class Tracker
        def initialize(topic_id, user_id = nil)
          @topic_id = topic_id
          @user_id = user_id
        end

        def start
          { :success => true, :message => { :tracker => { :topic_id => @topic_id, :toggl_entry_id => 'testID' } } }
        end
        def stop 
          active_entry = get_store
          if active_entry == []
            return { :success => false, :message => 'no active entry' }
          end

          set_store(nil)
          { :success => true, :message => nil }
        end

        def get_store
          PluginStore.get("procourse_time_tracker", "active:" + @user_id.to_s) || []
        end

        def set_store(record)
          PluginStore.set("procourse_time_tracker", "active:" + @user_id.to_s, record)
        end
      end
    end
  end
  let(:tracker) { ::TimeTracker::Tracker }
end
