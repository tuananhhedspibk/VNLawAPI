class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :article_id
      t.text :content
      t.text :title
      t.datetime :public_day
      t.datetime :effect_day
      t.string :effect_status

      t.timestamps
    end
  end
end
