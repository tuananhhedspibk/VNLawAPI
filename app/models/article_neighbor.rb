class ArticleNeighbor < ApplicationRecord
  belongs_to :source, class_name: "Article", foreign_key: "source_id"
  belongs_to :neighbor, class_name: "Article", foreign_key: "neighbor_id"
  validates :source_id, precense: true
  validates :neighbor_id, precense: true
end
