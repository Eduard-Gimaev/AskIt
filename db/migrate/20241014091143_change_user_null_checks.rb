class ChangeUserNullChecks < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :name, true
    change_column_null :users, :email, false
  end
end
