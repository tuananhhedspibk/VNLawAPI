class Index_modify_position < ActiveRecord::Base

	belongs_to :law_modify ,class_name: 'Article'
	belongs_to :modified_law, class_name: 'Article'
	
	
	validates :law_id, presence: true
	validates :modified_law_id, presence: true
	#bang relationship tu van ban sua doi sang van ban duoc sua doi
	end