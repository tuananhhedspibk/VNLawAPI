class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, {id: false} do |t|
      ## Database authenticatable
      t.string :id
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :status, default: "online"

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
