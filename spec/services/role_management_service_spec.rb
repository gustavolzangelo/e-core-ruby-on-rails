# spec/services/role_management_service_spec.rb
require 'rails_helper'

RSpec.describe RoleManagementService, type: :service do
  describe '#create_role' do
    context 'when the role does not already exist' do
      it 'creates a new role and returns success' do
        role_name = Faker::Job.unique.title
        service = RoleManagementService.new(name: role_name)
        result = service.create_role

        expect(result[:success]).to be true
        expect(result[:role]).to be_a(Role)
        expect(result[:role].name).to eq(role_name)
      end
    end

    context 'when the role already exists' do
      let!(:existing_role) { create(:role) }

      it 'does not create a new role and returns an error' do
        service = RoleManagementService.new(name: existing_role.name)
        result = service.create_role

        expect(result[:success]).to be false
      end
    end

    context 'when the role cannot be created due to validation errors' do
      it 'returns validation errors' do
        service = RoleManagementService.new(name: '')
        result = service.create_role

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Name can't be blank")
      end
    end
  end
end
