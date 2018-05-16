class Article < ApplicationRecord
  has_many :parts, class_name: 'Part',
    foreign_key: 'law_id'

  has_many :relationshipmodifies,
    foreign_key: "law_id",
    class_name: "Index_modify_position"

  has_many :modified_law,
    through: :relationships,
    source: :modified_law_id

  has_many :reverse_relationshipmodifies,
    foreign_key: "modified_law_id",
    class_name: "Index_modify_position"

  has_many :law_modify,
    through: :reverse_relationshipmodifies, source: :law_id

  def isLawModify?
    relationshipmodifies.present?
  end

  def isModifedLaw?
    reverse_relationshipmodifies.present?
  end

  searchkick  callbacks: false,
    index_name: "articles",batch_size: 1, merge_mappings: true, filterable: [:article_type, :agency_issued, :public_day],
    settings: {
      index: {
        analysis: {
          analyzer: {
            vnanalysis: {
              type: "custom",
              tokenizer: "vi_tokenizer",
              char_filter:  [ "html_strip" ],
              filter: [
                "icu_folding"
              ]
            }
          }
        }
      }
    },
    mappings: {
      article: {
        properties: {
          title: {
            type: "text",
            index: true,
            boost: 8,
            analyzer: "vnanalysis"
          },
          content: {
            type: "text",
            index: true,
            boost: 2,
            analyzer: "vnanalysis"
          },
          numerical_symbol: {
            type: "text",
            boost: 10,
            index: true
          },
          id: {
            type: "text",
            boost: 0,
            index: true
          },
          effect_day: {
            type: "date",
            boost: 0,
            index: true
          },
          effect_status: {
            type: "text",
            boost: 0,
            index: true
          }
        }
      }
    }
  def search_data
    {
      id: id,
      title: title,
      content: content,
      numerical_symbol: numerical_symbol,
      public_day: public_day,
      article_type: article_type,
      effect_day: effect_day,
      agency_issued: agency_issued,
      effect_status: effect_status
    }
  end

  class << self
    def filter_by_type opts = {}
      article_type = opts[:article_type]
      if article_type != nil
        self.where article_type: article_type
      end
    end
  end
end