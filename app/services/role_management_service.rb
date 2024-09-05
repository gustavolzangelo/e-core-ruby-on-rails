# frozen_string_literal: true

require 'httparty'

class RoleManagementService < ApplicationService
  include HTTParty

  base_uri ENV['EXTERNAL_SERVICE_BASE_URL']

  def initialize(name: nil, user_id: nil, team_id: nil)
    @name = name
    @user_id = user_id
    @team_id = team_id
  end

  def create_role
    return { success: false, errors: ['Role already exists'] } if role_exists?

    role = Role.new(name: @name)
    if role.save
      { success: true, role: }
    else
      { success: false, errors: role.errors.full_messages }
    end
  end

  def assign_role_to_member
    role = Role.find_by(name: @name)
    return { success: false, errors: ['Role not found'] } unless role

    user = fetch_user(@user_id)
    return { success: false, errors: ['User not found'] } unless user

    team = fetch_team(@team_id)
    return { success: false, errors: ['Team not found'] } unless team

    unless team['teamMemberIds'].include?(@user_id)
      return { success: false,
               errors: ["User doesn't belong to the team"] }
    end

    membership = Membership.find_or_initialize_by(user_id: @user_id, team_id: @team_id)
    membership.role = role
    if membership.save
      { success: true, membership: }
    else
      { success: false, errors: membership.errors.full_messages }
    end
  end

  def role_exists?
    Role.exists?(name: @name)
  end

  def fetch_user(user_id)
    cache_key = "/user/#{user_id}"

    parsed_response = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = HTTParty.get("#{ENV['EXTERNAL_SERVICE_BASE_URL']}/users/#{user_id}")
      response.code == 200 ? response.parsed_response : nil
    end

    return nil unless parsed_response.present?

    parsed_response
  rescue StandardError => e
    Rails.logger.error("Failed to fetch user: #{e.message}")
    nil
  end

  def fetch_team(team_id)
    cache_key = "/team/#{team_id}"

    parsed_response = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = HTTParty.get("#{ENV['EXTERNAL_SERVICE_BASE_URL']}/teams/#{team_id}")
      response.present? ? response.parsed_response : nil
    end

    return nil unless parsed_response.present?

    parsed_response
  rescue StandardError => e
    Rails.logger.error("Failed to fetch team: #{e.message}")
    nil
  end
end
