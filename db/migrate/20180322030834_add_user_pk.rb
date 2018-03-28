class AddUserPk < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
