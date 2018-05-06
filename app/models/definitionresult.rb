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

  def self.getDef
    definitions = Definitionresult.where(global_def: true)
    definitions.each do |x|
      x.sentence.gsub! '_', ' '
      x.sentence.gsub! '*', ' '
      x.concept.gsub! '_', ' '
      x.concept.gsub! '*', ' '
      x.concept.gsub! '"', ' '
      x.concept.gsub! '“', ' '
      x.concept.gsub! '”', ' '
      x.sentence.gsub! '"', ' '
      x.sentence.gsub! '“', ' '
      x.sentence.gsub! '”', ' '
      x.concept = (x.concept.strip).downcase 
      x.sentence = '<a href="#" class="definition-popover" data-toggle="popover" data-trigger="hover" data-content="'+x.sentence+'">'+x.concept+'</a>'
    end
    definitions
  end
end
