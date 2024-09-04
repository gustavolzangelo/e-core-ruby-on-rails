class MembershipsController < ApplicationController
  def create
    service = RoleManagementService.new(
      name: membership_params[:role_name],
      user_id: membership_params[:user_id],
      team_id: membership_params[:team_id]
    )

    result = service.assign_role_to_member

    if result[:success]
      render json: result[:membership], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_content
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:role_name, :user_id, :team_id)
  end

end
