class Section < ApplicationRecord
  belongs_to :article, class_name: 'Article', foreign_key: 'id'

  def laws
  	Law.where(law_id: self.law_id,part_index: self.part_index,chap_index: self.chap_index, sec_index: self.sec_index).order(sec_index: :asc)
  end
end