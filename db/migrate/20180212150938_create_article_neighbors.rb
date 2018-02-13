class CreateArticleNeighbors < ActiveRecord::Migration[5.1]
  def change
    create_table :article_neighbors do |t|
      t.string :source_id
      t.string :neighbor_id
      t.integer :level

      t.timestamps
    end
  end
end
