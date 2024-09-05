class AddUniquenessToUserIdTeamIdOnMembership < ActiveRecord::Migration[7.1]
  def change
    add_index :memberships, %i[user_id team_id], unique: true
  end
end
