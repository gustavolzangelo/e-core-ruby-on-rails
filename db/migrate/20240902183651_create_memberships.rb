# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships do |t|
      t.string :user_id
      t.string :team_id
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
