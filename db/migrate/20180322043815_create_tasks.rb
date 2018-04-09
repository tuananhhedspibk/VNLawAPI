class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :room, foreign_key: true, type: :string

      t.text :content
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
