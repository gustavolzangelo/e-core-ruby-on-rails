class RolesController < ApplicationController
  def create
    result = RoleManagementService.new(name: role_params[:name]).create_role
    if result[:success] == true
      render json: { role: result[:role] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_content
    end
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end