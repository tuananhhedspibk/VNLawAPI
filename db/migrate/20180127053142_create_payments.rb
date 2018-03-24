class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :uid
      t.string :refcode
      t.boolean :done
      t.integer :amount

      t.timestamps
    end
  end
end
