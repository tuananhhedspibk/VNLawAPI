class Chapter < ApplicationRecord
  belongs_to :article, class_name: 'Article', foreign_key: 'id'

  def sections
    Section.where(law_id: self.law_id,
      part_index: self.part_index,
      chap_index: self.chap_index).order(sec_index: :asc)
  end
end