class Definitionresult < ApplicationRecord
  def self.find_def(query)
    if query == nil or (query.strip) == ''
      return nil
    end
    definitions = Definitionresult.all
    definitions.each do |x|
      x.sentence.gsub! '_', ' '
      x.concept.gsub! '_', ' '
    end
    include_query = []
    for defi in definitions
        if defi.concept.include? query
          include_query.push defi
        end
    end
    if include_query.length  = 1
      return include_query.first
    end
    if include_query.length > 1
      return get_near_def(include_query,query.length)
    end
    return nil
  end

  def get_near_def (arr_def, standard_length)
    arr_def.sort {|a,b| (a.length - standard_length).abs >= (b.length - standard_length).abs ? 1 : -1 }
    return arr_def.first
  end

  def self.getDef (string)
    article = string.downcase
    results = []
    definitions = Definitionresult.where( "global_def = true and length(concept) >= 9").order('length(concept) desc')
    definitions.each do |x|
      x.sentence.gsub! '*', ' '
      x.concept.gsub! '_', ' '
      x.concept.gsub! '*', ' '
      x.concept.gsub! '"', ' '
      x.concept.gsub! '“', ' '
      x.concept.gsub! '”', ' '
      x.sentence.gsub! '"', ' '
      x.sentence.gsub! '“', ' '
      x.sentence.gsub! '”', ' '
      x.sentence.gsub! ' ', '_'
      x.concept = (x.concept.strip).downcase 
      if article.include? x.concept
        x.concept.gsub! '(', '\('
        x.concept.gsub! ')', '\)'
        x.sentence = '<a href="#" class="definition-popover" data-toggle="popover" data-trigger="hover" data-content="'+x.sentence+'">'
        if !(results.any? {|r| (r.concept == x.concept) ||  (r.concept.include? x.concept)})
          results.push(x)
        end
      end
    end
    results
  end
end
