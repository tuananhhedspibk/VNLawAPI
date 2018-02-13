class AddIndexToArticleNeighbors < ActiveRecord::Migration[5.1]
  def change
    add_index :article_neighbors, :source_id
    add_index :article_neighbors, :neighbor_id
    add_index :article_neighbors, [:source_id, :neighbor_id], unique: true
  end
end
