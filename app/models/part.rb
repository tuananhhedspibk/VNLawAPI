class Part < ApplicationRecord
  belongs_to :article, class_name: 'Article', foreign_key: 'id'

  def chapters
    Chapter.where(law_id: self.law_id,
      part_index: self.part_index).order(chap_index: :asc)
  end
end