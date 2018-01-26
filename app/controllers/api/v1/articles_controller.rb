class Api::V1::ArticlesController < ApplicationController
  before_action :get_article, only: [:show]

  def show
    if @article
      render json: {
        full_html: @article.full_html,
        index_html: @article.index_html,
        detail: @article.as_json(only: [:title, :numerical_symbol,
          :public_day, :day_report, :article_type, :source, :agency_issued, 
          :the_signer, :signer_title,:scope,:effect_day, :effect_status ])
      }, status: :ok
    else
      render json: {
        }, status: :not_found
    end
  end

  def index
    render json: {
      articles: Article.search_article_newest.as_json(only: [:id, :title,
      :public_day, :effect_day, :effect_status])
    }, status: :ok
  end

  private

  def get_article
    @article = Article.find_by id: params[:id]
  end

  def render_index_html
    if @article.content.length > 0 &&
        (@article.index_html == nil || @article.index_html.length == 0)
      @index_html = ''
      @full_html =''
      remove_redundant_element

      @parts = @article.parts.order(part_index: :asc)
      @start_index = 0
      @parts.each do |part|
        if part.totalpart > 0
          insert_big_tag(part, 1)
        end

        chapters = part.chapters
        chapters.each do |chapter|
          if chapter.totalchap > 0
            insert_big_tag(chapter, 2)
          end

          secs = chapter.sections
          secs.each do |sec|
            if sec.totalsec > 0
              insert_big_tag(sec, 3)
            end

            laws = sec.laws
            laws.each do |law|
              if law.totallaw> 0
                insert_big_tag(law, 4)
              end

              items = law.items
              items.each do |item|
                if item.totalitem > 0
                  insert_small_tag(item, 1)
                end

                points = item.points
                points.each do |point|
                  if point.totalpoint > 0
                    insert_small_tag(point, 2)
                  end
                end
              end
            end
          end
        end
      end
      @article.update_attributes(index_html: @index_html)
      @article.update_attributes(full_html: @full_html)
    end
  end
  
  def remove_redundant_element
    link_regex = /\<a\sname\=\"([p|P]han\_\w*\S*)*(\_*[c|C]huong\_\w{1,})*(\_*[m|M]uc\_\d{1,})*(\_*[D|d]ieu\_\d{1,})*\"\>\<\/\w\>/
    
    @full_html = @article.full_html
    @full_html.gsub!(link_regex, '')
    @full_html.gsub!('\n', '')
    @full_html.gsub!('\r', '')
    @full_html.gsub!('\t', '')
  end

  def get_title(article ,post)
    indexSet = post.split('_')
    partIndex = nil
    chapIndex = nil
    secIndex = nil
    lawIndex = nil
    itemIndex = nil
    pointIndex = nil

    (1..indexSet.length).each do |x|
      case x
        when 1
          partIndex = indexSet[0].to_i == 0? nil : indexSet[0].to_i - 1
        when 2
          chapIndex = indexSet[1].to_i == 0? nil : indexSet[1].to_i - 1
        when 3
          secIndex = indexSet[2].to_i == 0? nil : indexSet[2].to_i - 1
        when 4
          lawIndex = indexSet[3].to_i == 0? nil : indexSet[3].to_i - 1
        when 5
          itemIndex = indexSet[4].to_i == 0? nil : indexSet[4].to_i - 1
        when 6
          pointIndex = indexSet[5].to_i == 0? nil : indexSet[5].to_i - 1
      end
    end

    if lawIndex == nil
      return nil
    end

    if pointIndex != nil
      points = article.points.where(point_index: pointIndex)
      points.each do |point|
        if point.part_index == partIndex &&
          point.chap_index == chapIndex &&
          point.sec_index == secIndex &&
          point.law_index == lawIndex &&
          point.item_index == itemIndex
            return point.point_content
        end
      end
    elsif itemIndex != nil
      items = article.items.where(item_index: itemIndex)
      items.each do |item|
        if item.part_index == partIndex &&
          item.chap_index == chapIndex &&
          item.sec_index == secIndex &&
          item.law_index == lawIndex
            return item.item_content
        end
      end
    elsif
      laws = article.laws.where(law_index: lawIndex)
      laws.each do |law|
        if law.part_index == partIndex &&
          law.chap_index == chapIndex &&
          law.sec_index == secIndex
            return law.law_content
        end
      end
    end
    return nil
  end

  def reform_html(string)
    symbol = ['_','*','#','\.']
    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub(/\n/,'<br>')
  end

  def convert2regex(string)
    string =  eval("string")
    string = string.force_encoding("UTF-8")
    symbol = ['_','*','#',"\n"]

    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub('\.','.')
    string = string.strip()
    index = 1
    string = string.gsub('(','?')
    string = string.gsub(')','!')

    for i in 1..(string.length-2)
      string = string[0,index] + '(<[^<]+>)*' + string[index,string.length]
      index += 11
    end

    string = string.gsub('?','\\(')
    string = string.gsub('!','\\)')
    string = string.gsub("/",'\/')
    string = string.gsub(".","\\.")
    string = string.gsub(/\s/,'\s+')
    return string
  end

  def firstStrip(string)
    find = /^(\n|\s)+/.match(string)

    if find != nil
      string = string[find.end(0),string.length]
    end

    find = /\n/.match(string)

    if find != nil
      string = string[0,find.begin(0)]
    end
    return string
  end

  def insert_big_tag (object, type)
    position = ""
    case type
      when 1
        position = "#{object.part_index+1}_0_0_0_0_0"
        insert_html_tag(object.name_part, object.name_part,
          position, 'part_index', true)
      when 2
        position = "#{object.part_index+1}_#{object.chap_index+1}_0_0_0_0"
        insert_html_tag(object.chap_name, object.chap_name,
          position, 'chap_index', true)
      when 3
        position = "#{object.part_index+1}_#{object.chap_index+1}_
          #{object.sec_index+1}_0_0_0"
        insert_html_tag(object.sec_name, object.sec_name,
          position, 'sec_index', true)
      when 4
        position = "#{object.part_index+1}_#{object.chap_index+1}_
          #{object.sec_index+1}_#{object.law_index+1}_0_0"
        insert_html_tag(firstStrip(object.law_content),
          object.law_name, position, 'law_index', true)
      end
  end

  def insert_small_tag (object, type)
    position = ""
    case type
      when 1
        position = "#{object.part_index+1}_#{object.chap_index+1}_
          #{object.sec_index+1}_#{object.law_index+1}_
          #{object.item_index+1}_0"
        insert_html_tag(firstStrip(object.item_content), 
          object.item_name, position, 'item_index', false)
      when 2
        position = "#{object.part_index+1}_#{object.chap_index+1}_
          #{object.sec_index+1}_#{object.law_index+1}_
          #{object.item_index+1}_#{object.point_index+1}"
        insert_html_tag(firstStrip(object.point_content),
          object.point_name, position, 'point_index', false)
      end
  end

  def insert_html_tag (string, name, position, type, style)
    pattern = '\s*(<[^<]+>)\s*' + convert2regex(string) + '\s*(<[^<]+>)\s*'
    find = /#{pattern}/.match(@full_html[@start_index,@full_html.length])
    if find != nil
      html_insert = '<a id="' + position + '"></a>'
      @full_html = @full_html[0,@start_index+find.begin(0)]
        + html_insert + @full_html[@start_index
        + find.begin(0),@full_html.length]
      @start_index = find.begin(0)
      if style == true
        @index_html +=  '<div class="' + type + '">
          <a class="internal_link" href="#' + position + '">'
          + name + '</a></div>'
      end
    end
  end

  def sumary_to_position(object)
    if  object.part_modify_index != nil
      part_index =  object.part_modify_index + 1
    else 
      part_index = 0
    end

    if  object.chap_modify_index != nil
      chap_index =  object.chap_modify_index + 1
    else 
      chap_index = 0
    end

    if  object.sec_modify_index != nil
      sec_index =  object.sec_modify_index + 1
    else 
      sec_index = 0
    end

    if  object.law_modify_index != nil
      law_index =  object.law_modify_index + 1
    else 
      law_index = 0
    end

    if  object.item_modify_index != nil
      item_index =  object.item_modify_index + 1
    else 
      item_index = 0
    end

    if  object.point_modify_index != nil
      point_index =  object.point_modify_index + 1
    else 
      point_index = 0
    end
    return position = "#{part_index}_#{chap_index}_
      #{sec_index}_#{law_index}_#{item_index}_#{point_index}"
  end
end
