class ChangeNameToUniqueAndNotNullOnRoles < ActiveRecord::Migration[7.1]
  def change
    change_column_null :roles, :name, false
    add_index :roles, :name, unique: true
  end
end
