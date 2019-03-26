require 'rails_helper'
require_relative '../dummy_tracker'

describe TimeTracker::TrackerController do

  include_context 'dummy tracker'

  before(:each) do
    @user = Fabricate(:user)
    @topic = Fabricate(:topic)
    tracker
    sign_in(@user)
  end

  describe 'starting a timer' do
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

  describe 'stopping a timer'
  describe 'getting a timer'
  describe 'getting workspaces'

end
