class AddRoomPk < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE rooms ADD PRIMARY KEY (id);"
  end
end
