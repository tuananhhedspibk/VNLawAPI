class Point < ApplicationRecord
  belongs_to :article, class_name: 'Article', foreign_key: 'id' 
end