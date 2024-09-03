class RolesController < ApplicationController
  def create
    role = RoleManagementService.new(name: role_params[:name]).create_role

    if role[:success] == true
      render json: role, status: :created, location: role
    else
      render json: role.errors, status: :unprocessable_content
    end
  end

  private
  def role_params
    params.require(:role).permit(:name)
  end
end