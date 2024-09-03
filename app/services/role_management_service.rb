# frozen_string_literal: true

class RoleManagementService < ApplicationService

  def initialize(name:)
    @name = name
  end

  def create_role
    return { success: false, errors: ['Role already exists'] } if role_exists?
    role = Role.new(name: @name)
    if role.save
      { success: true, role: role }
    else
      { success: false, errors: role.errors.full_messages }
    end
  end

  def role_exists?
    Role.exists?(name: @name)
  end
end
