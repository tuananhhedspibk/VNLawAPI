class Article < ApplicationRecord
  # has_many :parts, class_name: 'Part',
  #   foreign_key: 'law_id'

  # has_many :relationshipmodifies,
  #   foreign_key: "law_id",
  #   class_name: "Index_modify_position"

  # has_many :modified_law,
  #   through: :relationships,
  #   source: :modified_law_id

  # has_many :reverse_relationshipmodifies,
  #   foreign_key: "modified_law_id",
  #   class_name: "Index_modify_position"

  # has_many :law_modify,
  #   through: :reverse_relationshipmodifies,
  #   source: :law_id

  # def isLawModify?
  #   relationshipmodifies.present?
  # end

  # def isModifedLaw?
  #   reverse_relationshipmodifies.present?
  # end

  has_many :neighbors, through: :article_neighbor,
    source: :neighbor

  searchkick batch_size: 200, merge_mappings: true,
    settings: {
      analysis: {
        analyzer: {
          vnanalysis: {
            tokenizer: "vi_tokenizer",
            char_filter:  [ "html_strip" ],
            filter: [
              "icu_folding"
            ]
          }
        }
      }
    },
    mappings: {
      article: {
        properties: {
          title: {
            type: "text",
            index: "true",
            boost: 10
          },
          content: {
            type: "text",
            index: "true",
            boost: 10
          },
        }
      }
    }

  class << self
    def filter_by_type opts = {}
      article_type = opts[:article_type]
      if article_type != nil
        self.where article_type: article_type
      end
    end
  end
end
