class CreateArticleTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :article_topics do |t|
      t.references :article, foreign_key: true
      t.text :topics

      t.timestamps
    end
  end
end
