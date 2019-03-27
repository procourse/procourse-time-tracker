require 'rails_helper'
require_relative '../dummy_tracker'

describe TimeTracker::TrackerController do

  let(:active_timer) do
    PluginStore.set('procourse_time_tracker', "active:#{@user.id}", {
      :topic_id => @topic.id,
      :toggl_entry_id => 'testID'
    })
  end
  include_context 'dummy tracker'

  describe 'starting a timer' do
    context 'as an anonymous user' do
      before(:each) do
        @topic = Fabricate(:topic)
        tracker
      end
      it 'should raise the right error' do
        post '/time-tracker/start.json', params: { :topic_id => @topic.id }
        expect(response.status).to eq(403)
      end
    end

    context 'with a logged in user' do
      before(:each) do
        @user = Fabricate(:user)
        @topic = Fabricate(:topic)
        tracker
        sign_in(@user)
      end
      context 'provided an api key' do
        it 'successfully starts the timer' do
          @user.custom_fields["toggl_api_key"] = "testAPIKey"
          @user.save
          post '/time-tracker/start.json', params: { :topic_id => @topic.id }
          expect(response.status).to eq(200)
        end
      end
      context 'without an api key' do
        it 'should raise the right error' do
          post '/time-tracker/start.json', params: { :topic_id => @topic.id }
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'stopping a timer' do
    before(:each) do
      @user = Fabricate(:user)
      @topic = Fabricate(:topic)
      @user.custom_fields["toggl_api_key"] = "testAPIKey"
      @user.save
      tracker
      sign_in(@user)
    end

    context 'provided an active timer' do
      it 'successfully stops the timer' do
        active_timer
        post '/time-tracker/stop.json'
        expect(response.status).to eq(200)
      end
    end

    context 'without an active timer' do
      it 'should raise the right error' do
        post '/time-tracker/stop.json'
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'getting a timer' do
    before(:each) do
      @user = Fabricate(:user)
      @topic = Fabricate(:topic)
      @user.custom_fields["toggl_api_key"] = "testAPIKey"
      @user.save
      tracker
      sign_in(@user)
    end

    it 'successfully retrieves the time entry' do
      get '/time-tracker/get-timer.json'
      expect(response.status).to eq(200)
    end
  end

  describe 'getting workspaces' do
    before(:each) do
      @user = Fabricate(:user)
      @topic = Fabricate(:topic)
      @user.custom_fields["toggl_api_key"] = "testAPIKey"
      @user.save
      tracker
      sign_in(@user)
    end

    it 'successfully retrieves the workspaces' do
      get '/time-tracker/get-workspaces.json'
      expect(response.status).to eq(200)
    end
  end
end
