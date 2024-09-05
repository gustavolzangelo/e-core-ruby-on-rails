# frozen_string_literal: true

class Membership < ApplicationRecord
  validates :user_id, uniqueness: { scope: :team_id, message: 'User is already a member of this team' }
  belongs_to :role
end
