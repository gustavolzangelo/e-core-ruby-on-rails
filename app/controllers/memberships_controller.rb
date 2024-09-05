# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :validate_create_params, only: [:create]
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

  def role
    membership = Membership.includes(:role).find(params[:id])

    if membership.role
      render json: { role: membership.role }, status: :ok
    else
      render json: { error: 'Role not found' }, status: :not_found
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:role_name, :user_id, :team_id)
  end

  def validate_create_params
    if membership_params[:role_name].blank? || membership_params[:user_id].blank? || membership_params[:team_id].blank?
      render json: { errors: ['Role name, user id, and team id must be provided'] }, status: :unprocessable_content
    end
  end
end
