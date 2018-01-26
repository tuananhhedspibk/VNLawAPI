class CreateLawyerSpecializes < ActiveRecord::Migration[5.1]
  def change
    create_table :lawyer_specializes do |t|
      t.references :lawyer, foreign_key: true
      t.references :specialization, foreign_key: true
      t.timestamps
    end
  end
end
