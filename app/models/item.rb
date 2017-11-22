class Item < ApplicationRecord
  belongs_to :article, class_name: 'Article', foreign_key: 'id'
  def points
  	Point.where(law_id: self.law_id,part_index: self.part_index,chap_index: self.chap_index, sec_index: self.sec_index, law_index: self.law_index,item_index: self.item_index).order(sec_index: :asc)
  end
end