class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true, type: :string

      t.string :userName
      t.string :displayName
      t.string :avatar
      t.datetime :birthday

      t.timestamps
    end
    add_index :profiles, :userName, unique: true
  end
end
