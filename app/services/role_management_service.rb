# frozen_string_literal: true

class RoleManagementService < ApplicationService

  def initialize(name:)
    @name = name
  end

  def create_role
    role = Role.new(name: @name)
    if role.save
      { success: true, role: role }
    else
      { success: false, errors: role.errors.full_messages }
    end
  end
end
