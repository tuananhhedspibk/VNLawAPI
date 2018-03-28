class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.integer :name

      t.timestamps
    end
  end
end
