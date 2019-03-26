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
      end
    end
  end
  let(:tracker) { ::TimeTracker::Tracker }
end
