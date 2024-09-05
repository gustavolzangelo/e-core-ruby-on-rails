# frozen_string_literal: true

# spec/requests/roles_spec.rb
require 'rails_helper'

RSpec.describe 'Roles API', type: :request do
  describe 'POST /roles' do
    context 'when the role is created successfully' do
      let(:role_name) { Faker::Job.unique.title }
      let(:valid_params) { { role: { name: role_name } } }

      it 'returns http status created and the role in the response' do
        post '/roles', params: valid_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['role']['name']).to eq(role_name)
      end
    end

    context 'when the role already exists' do
      let!(:existing_role) { create(:role) }
      let(:duplicate_params) { { role: { name: existing_role.name } } }

      it 'returns http status unprocessable_entity and an error message' do
        post '/roles', params: duplicate_params

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Role already exists')
      end
    end

    context 'when the role cannot be created due to validation errors' do
      let(:invalid_params) { { role: { name: '' } } }

      it 'returns http status unprocessable_entity and validation errors' do
        post '/roles', params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
      end
    end
  end
end
