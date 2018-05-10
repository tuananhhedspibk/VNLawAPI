class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.references :lawyer, foreign_key: true
      t.references :user, foreign_key: true, type: :string

      t.text :description

      t.timestamps
    end
  end
end
