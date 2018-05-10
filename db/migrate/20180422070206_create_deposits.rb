class CreateDeposits < ActiveRecord::Migration[5.1]
  def change
    create_table :deposits do |t|
      t.references :user, foreign_key: true, type: :string
      t.string :refcode
      t.boolean :done
      t.integer :amount

      t.timestamps
    end
  end
end
