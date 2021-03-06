require 'rails_helper'

RSpec.describe 'ScannedResourcesController', type: :request do
  let(:user) { FactoryGirl.create(:curation_concern_creator) }
  let(:scanned_resource) { FactoryGirl.create(:scanned_resource) }

  before do
    login_as(user, scope: :user)
  end

  it 'User creates a new scanned resource', vcr: { cassette_name: 'bibdata', allow_playback_repeats: true }do
    get '/concern/scanned_resources/new'

    expect(response).to render_template('curation_concerns/scanned_resources/new')

    valid_params = {
      title: ['My Resource'],
      source_metadata_identifier: '2028405',
      access_policy: 'something',
      use_and_reproduction: 'something else'
    }

    post '/concern/scanned_resources', scanned_resource: valid_params

    resource_path = curation_concerns_scanned_resource_path(assigns(:curation_concern))
    expect(response).to redirect_to(resource_path)
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.status).to eq 200
    expect(response.body).to include('<h1>The Giant Bible of Mainz; 500th anniversary, April fourth, fourteen fifty-two, April fourth, nineteen fifty-two.')
  end
end
