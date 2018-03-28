class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :room, foreign_key: true, type: :string

      t.datetime :startTime
      t.datetime :endTime
      t.integer :ammount
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
