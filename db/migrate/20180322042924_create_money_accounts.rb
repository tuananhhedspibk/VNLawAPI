class CreateMoneyAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :money_accounts do |t|
      t.references :profile, foreign_key: true
      t.integer :ammount, default: 0

      t.timestamps
    end
  end
end
