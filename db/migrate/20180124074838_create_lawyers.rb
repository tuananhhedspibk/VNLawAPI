class CreateLawyers < ActiveRecord::Migration[5.1]
  def change
    create_table :lawyers do |t|
      t.string :name
      t.string :fb_id, default: ""
      t.string :photo_url, default: ""
      t.float :rate, default: 0
      t.text :intro, default: ""
      t.integer :cost, default: 0
      t.integer :view_count, default: 0

      t.timestamps
    end
  end
end
