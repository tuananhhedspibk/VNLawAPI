class CreateUserRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_roles do |t|
      t.references :role, foreign_key: true
      t.references :user, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
