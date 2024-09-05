# frozen_string_literal: true

class RolesController < ApplicationController
  def create
    result = RoleManagementService.new(name: role_params[:name]).create_role
    if result[:success] == true
      render json: { role: result[:role] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_content
    end
  end

  def membership
    role = Role.find(params[:id])

    return render json: { error: 'Role not found' }, status: :not_found unless role.present?

    memberships = Membership.where(role_id: role.id)

    render json: { memberships: }, status: :ok
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end
