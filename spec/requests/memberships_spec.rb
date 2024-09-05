# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Memberships API', type: :request do
  let(:role) { create(:role, name: Faker::Job.unique.title) }
  let(:user_id) { 'fd282131-d8aa-4819-b0c8-d9e0bfb1b75c' }
  let(:team_id) { '7676a4bf-adfe-415c-941b-1739af07039b' }

  before do
    stub_request(:get, "#{ENV['EXTERNAL_SERVICE_BASE_URL']}/users/#{user_id}")
      .to_return(status: 200, body: { id: user_id,
                                      name: 'John Doe' }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  context 'when the assignment is successful' do
    before do
      stub_request(:get, "#{ENV['EXTERNAL_SERVICE_BASE_URL']}/teams/#{team_id}")
        .to_return(status: 200, body: { id: team_id, name: 'Team Alpha',
                                        teamMemberIds: [user_id] }.to_json,
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'assigns the role to the team member and returns the membership' do
      post '/memberships', params: {
        membership: {
          role_name: role.name,
          user_id:,
          team_id:
        }
      }

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)

      expect(json_response['role_id']).to eq(role.id)
      expect(json_response['user_id']).to eq(user_id)
      expect(json_response['team_id']).to eq(team_id)
    end
  end

  context 'when the user does not belong to the team' do
    before do
      stub_request(:get, "#{ENV['EXTERNAL_SERVICE_BASE_URL']}/teams/#{team_id}")
        .to_return(status: 200, body: { id: team_id, name: 'Team Alpha',
                                        teamMemberIds: ['some-other-user-id'] }.to_json,
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an error when the user does not belong to the team' do
      post '/memberships', params: {
        membership: {
          role_name: role.name,
          user_id:,
          team_id:
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("User doesn't belong to the team")
    end
  end

  context 'when the team is not found' do
    before do
      stub_request(:get, "#{ENV['EXTERNAL_SERVICE_BASE_URL']}/teams/#{team_id}")
        .to_return(status: 404, body: '')
    end

    it 'returns an error when the team is not found' do
      post '/memberships', params: {
        membership: {
          role_name: role.name,
          user_id:,
          team_id:
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include('Team not found')
    end
  end

  context 'when the role does not exist' do
    before do
      stub_request(:get, "#{ENV['EXTERNAL_SERVICE_BASE_URL']}/teams/#{team_id}")
        .to_return(status: 200, body: { id: team_id, name: 'Team Alpha',
                                        teamMemberIds: [user_id] }.to_json,
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns an error when the role is not found' do
      post '/memberships', params: {
        membership: {
          role_name: 'NonExistentRole',
          user_id:,
          team_id:
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include('Role not found')
    end
  end

  context 'when looking up the role for a membership' do
    let(:membership) { create(:membership, role:, user_id:, team_id:) }
    let(:user_id) { Faker::Internet.uuid }
    let(:team_id) { Faker::Internet.uuid }

    it 'returns the role associated with the membership' do
      get "/memberships/#{membership.id}/role"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['role']['id']).to eq(role.id)
      expect(json_response['role']['name']).to eq(role.name)
    end

    context 'when the membership is not found' do
      it 'returns an error' do
        get "/memberships/#{Faker::Internet.uuid}/role"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
