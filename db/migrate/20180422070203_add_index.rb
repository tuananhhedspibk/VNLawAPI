class AddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :reviews, [:user_id, :lawyer_id]
    add_index :user_roles, [:user_id, :role_id]
  end
end
