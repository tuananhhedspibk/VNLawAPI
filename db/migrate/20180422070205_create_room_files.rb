class CreateRoomFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :room_files do |t|
      t.references :room, foreign_key: true
      t.references :content_type, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
