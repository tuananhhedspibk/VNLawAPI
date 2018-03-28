class CreateDepositHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :deposit_histories do |t|
      t.references :money_account, foreign_key: true
      t.integer :ammount

      t.timestamps
    end
  end
end
