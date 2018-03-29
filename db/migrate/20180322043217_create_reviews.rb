class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true, null: false, type: :string
      t.references :lawyer, foreign_key: true, null: false

      t.text :content
      t.float :star, default: 0

      t.timestamps
    end
  end
end
