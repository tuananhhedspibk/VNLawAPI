class CreateLawyers < ActiveRecord::Migration[5.1]
  def change
    create_table :lawyers do |t|
      t.references :user, foreign_key: true, type: :string     

      t.text :achievement
      t.string :cardNumber
      t.string :certificate
      t.text :education
      t.text :intro
      t.integer :price
      t.integer :exp
      t.float :rate
      t.text :workPlace

      t.timestamps
    end
  end
end
