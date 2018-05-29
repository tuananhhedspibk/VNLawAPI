class Api::V1::ArticlesController < ApplicationController
  before_action :get_article, only: [:show]

  def show
    if @article
      render json: {
        full_html: @article.full_html,
        index_html: @article.index_html,
        modified_arr: @modified_position,
        modify_arr: @modifies_position,
        detail: @article.as_json(only: [:title, :numerical_symbol,
          :public_day, :day_report, :article_type, :source, :agency_issued, 
          :the_signer, :signer_title,:scope,:effect_day, :effect_status, :topics] ),
        neighbors: @neighbors
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
    if @article
      @neighbors = []
      if @article.neighbors
        neighbors_ids = @article.neighbors.split(" ")
        @neighbors = Article.where(id: neighbors_ids)
          .select("id, title, numerical_symbol")
      end
      if @article.parts.length > 0
        render_index_html
        @modified_position = Array.new
        @modifies_position = Array.new
        if @article.isModifedLaw?
            insert_html_modified_law
        end
        if @article.isLawModify?
          render_law_modify_json
        end
      end
    end
  end

  def render_index_html
    if @article.content.length > 0 &&
        (@article.index_html == nil || @article.index_html.length == 0)
      @index_html = ''
      @full_html =''
      remove_redundant_element
      replace_search_link
      @parts = @article.parts.order(part_index: :asc)
      @start_index = 0
      @parts.each do |part|
        if part.totalpart > 0
          insert_big_tag(part, 1)
        end

        chapters = part.chapters.order(chap_index: :asc)
        chapters.each do |chapter|
          if chapter.totalchap > 0
            insert_big_tag(chapter, 2)
          end

          secs = chapter.sections.order(sec_index: :asc)
          secs.each do |sec|
            if sec.totalsec > 0
              insert_big_tag(sec, 3)
            end

            laws = sec.laws.order(law_index: :asc)
            laws.each do |law|
              if law.totallaw> 0
                insert_big_tag(law, 4)
              end

              items = law.items.order(item_index: :asc)
              items.each do |item|
                if item.totalitem > 0
                  insert_small_tag(item, 1)
                end

                points = item.points.order(point_index: :asc)
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
      replace_definitions
      if @article.isLawModify?
        insert_html_law_modify
      end

      @article.update_attribute(:full_html, @full_html)
      @article.update_attribute(:index_html, @index_html)
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
      points = Point.where(law_id: article.id, point_index: pointIndex)
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
      items = Item.where(law_id: article.id, item_index: itemIndex)
      items.each do |item|
        if item.part_index == partIndex &&
          item.chap_index == chapIndex &&
          item.sec_index == secIndex &&
          item.law_index == lawIndex
            return item.item_content
        end
      end
    elsif
      laws = Law.where(law_id: article.id, law_index: lawIndex)
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
    symbol = ['_','*','#']
    symbol.each do |a| 
      string = string.gsub(a,"")
    end
    string = string.gsub(/\n/,'<br>')
  end

  def convert2regex(string)
    string =  eval("string")
    string = string.force_encoding("UTF-8")
    symbol = ['_','*','#',"\n",'\\']

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
    string = string.gsub(/\s/,'(\s|&nbsp;| )+')
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
        position = "#{object.part_index+1}_#{object.chap_index+1}_" + 
          "#{object.sec_index+1}_0_0_0"
        insert_html_tag(object.sec_name, object.sec_name,
          position, 'sec_index', true)
      when 4
        position = "#{object.part_index+1}_#{object.chap_index+1}_" + 
          "#{object.sec_index+1}_#{object.law_index+1}_0_0"
        insert_html_tag(firstStrip(object.law_content),
          object.law_name, position, 'law_index', true)
      end
  end

  def insert_small_tag (object, type)
    position = ""
    case type
      when 1
        position = "#{object.part_index+1}_#{object.chap_index+1}_" +
          "#{object.sec_index+1}_#{object.law_index+1}_#{object.item_index+1}_0"
        insert_html_tag(firstStrip(object.item_content), 
          object.item_name, position, 'item_index', false)
      when 2
        position = "#{object.part_index+1}_#{object.chap_index+1}_" +
          "#{object.sec_index+1}_#{object.law_index+1}_#{object.item_index+1}_#{object.point_index+1}"
        insert_html_tag(firstStrip(object.point_content),
          object.point_name, position, 'point_index', false)
      end
  end

  def insert_html_tag (string, name, position, type, style)
    pattern = '(\s|&nbsp;| )*(<[^<]+>)(\s|&nbsp;| )*' + convert2regex(string)
    find = (/#{pattern}/m).match(@full_html[@start_index,@full_html.length])
    if find != nil
      html_insert = '<a class="article-position" name="' + position + '"></a>'
      @full_html = @full_html[0,@start_index+find.begin(0)] + html_insert + @full_html[@start_index + find.begin(0),@full_html.length]
      @start_index += find.end(0)
      if style == true
        @index_html +=  '<div class="' + type + '">
          <a class="internal_link" href="#' + position + '">' + name + '</a></div>'
      end
    end
  end

  def sumary_to_position(object)
    part_name = nil
    chap_name = nil
    sec_name = nil
    law_name = nil
    item_name = nil
    point_name = nil
    if  object.part_modify_index != nil
      part_index =  object.part_modify_index + 1
      part = Part.where(law_id: object.modified_law_id, part_index: object.part_modify_index).first
      if part
        part_name = part.name_part
      end
    else 
      part_index = 0
    end

    if  object.chap_modify_index != nil
      chap_index =  object.chap_modify_index + 1
      chap = Chapter.where(law_id: object.modified_law_id, part_index: object.part_modify_index,
          chap_index: object.chap_modify_index).first
      if chap.chap_name
        chap_name = chap.chap_name
      end
    else 
      chap_index = 0
    end

    if  object.sec_modify_index != nil
      sec_index =  object.sec_modify_index + 1
      sec = Section.where(law_id: object.modified_law_id, part_index: object.part_modify_index,
          chap_index: object.chap_modify_index, sec_index: object.sec_modify_index ).first
      if sec.sec_name
        sec_name = sec.sec_name
      end
    else 
      sec_index = 0
    end

    if  object.law_modify_index != nil
      law_index =  object.law_modify_index + 1
      law = Law.where(law_id: object.modified_law_id, part_index: object.part_modify_index,
          chap_index: object.chap_modify_index, sec_index: object.sec_modify_index, law_index: object.law_modify_index ).first
      if law.law_name
        law_name = law.law_name
      end
    else 
      law_index = 0
    end

    if  object.item_modify_index != nil
      item_index =  object.item_modify_index + 1
      item = Item.where(law_id: object.modified_law_id, part_index: object.part_modify_index,chap_index: object.chap_modify_index, 
        sec_index: object.sec_modify_index, law_index: object.law_modify_index, item_index: object.item_modify_index ).first
      if item.item_name
        item_name = 'Khoản ' + item.item_name
      end
    else 
      item_index = 0
    end

    if  object.point_modify_index != nil
      point_index =  object.point_modify_index + 1
      point = Point.where(law_id: object.modified_law_id, part_index: object.part_modify_index,chap_index: object.chap_modify_index, 
        sec_index: object.sec_modify_index, law_index: object.law_modify_index, item_index: object.item_modify_index, 
        point_index: object.point_modify_index).first
      if point.point_name
        point_name = 'Điểm ' + point.point_name
      end
    else 
      point_index = 0
    end
    title = [point_name, item_name, law_name,  sec_name, chap_name, part_name].compact.join(' ')
    position = "#{part_index}_#{chap_index}_#{sec_index}_#{law_index}_#{item_index}_#{point_index}"
    return position,title
  end

  def get_next_pst(object)
    if  object.part_modify_index != nil
      part_index =  object.part_modify_index
    else 
      part_index = nil
    end

    if  object.chap_modify_index != nil
      chap_index =  object.chap_modify_index
    else 
      chap_index = nil
    end

    if  object.sec_modify_index != nil
      sec_index =  object.sec_modify_index
    else 
      sec_index = nil
    end

    if  object.law_modify_index != nil
      law_index =  object.law_modify_index
    else 
      law_index = nil
    end

    if  object.item_modify_index != nil
      item_index =  object.item_modify_index
    else 
      item_index = nil
    end

    if  object.point_modify_index != nil
      point_index =  object.point_modify_index
    else 
      point_index = nil
    end
    if point_index && Point.exists?(law_id: object.modified_law_id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index, item_index: item_index, point_index: point_index+1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index+1}_#{item_index+1}_#{point_index+2}"
    end
    if item_index && Item.exists?(law_id: object.modified_law_id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index, item_index: item_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index+1}_#{item_index + 2}_0"
    end  
    if law_index && Law.exists?(law_id: object.modified_law_id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index + 2}_0_0"
    end
    if sec_index && Section.exists?(law_id: object.modified_law_id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index + 2}_0_0_0"
    end
    if chap_index && Chapter.exists?(law_id: object.modified_law_id, part_index: part_index, chap_index: chap_index + 1)
      return "#{part_index+1}_#{chap_index + 2}_0_0_0_0"
    end
    if part_index && Part.exists?(law_id: object.modified_law_id, part_index: part_index + 1)
      return "#{part_index + 2}_0_0_0_0_0"
    end
    return nil
  end

  def get_next_post_by_post(object)
    indexSet = object.split('_')
    part_index = nil
    chap_index = nil
    sec_index = nil
    law_index = nil
    item_index = nil
    point_index = nil

    (1..indexSet.length).each do |x|
      case x
        when 1
          part_index = indexSet[0].to_i == 0? nil : indexSet[0].to_i - 1
        when 2
          chap_index = indexSet[1].to_i == 0? nil : indexSet[1].to_i - 1
        when 3
          sec_index = indexSet[2].to_i == 0? nil : indexSet[2].to_i - 1
        when 4
          law_index = indexSet[3].to_i == 0? nil : indexSet[3].to_i - 1
        when 5
          item_index = indexSet[4].to_i == 0? nil : indexSet[4].to_i - 1
        when 6
          point_index = indexSet[5].to_i == 0? nil : indexSet[5].to_i - 1
      end
    end

    if point_index && Point.exists?(law_id: @article.id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index, item_index: item_index, point_index: point_index+1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index+1}_#{item_index+1}_#{point_index+2}"
    end
    if item_index && Item.exists?(law_id: @article.id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index, item_index: item_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index+1}_#{item_index + 2}_0"
    end  
    if law_index && Law.exists?(law_id: @article.id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index, law_index: law_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index+1}_#{law_index + 2}_0_0"
    end
    if sec_index && Section.exists?(law_id: @article.id, part_index: part_index, chap_index: chap_index,
        sec_index: sec_index + 1)
      return "#{part_index+1}_#{chap_index+1}_#{sec_index + 2}_0_0_0"
    end
    if chap_index && Chapter.exists?(law_id: @article.id, part_index: part_index, chap_index: chap_index + 1)
      return "#{part_index+1}_#{chap_index + 2}_0_0_0_0"
    end
    if part_index && Part.exists?(law_id: @article.id, part_index: part_index + 1)
      return "#{part_index + 2}_0_0_0_0_0"
    end
    return nil
  end

  def replace_search_link
    pattern = '<a[^>]+vbpq-timkiem[^>]+>'
    find = (/#{pattern}/m).match(@full_html)
    while find
      len = find.length
      for i in 1..len
        replace_link =convert_replace_link(find[i-1])
        @full_html = @full_html[0,find.begin(i-1)] + replace_link + @full_html[find.end(i-1),@full_html.length]
        break
      end
      find = (/#{pattern}/m).match(@full_html)
    end
  end

  def convert_replace_link (string)
    pattern = '<a[^>]+vbpq-timkiem[^>]+Keyword='
    findStart = (/#{pattern}/i).match(string)
    pattern = '&'
    findEnd = (/#{pattern}/i).match(string[findStart.end(0),string.length])
    if findStart && findEnd
      return '<a target="_blank" class="article-searchlink" href="/searchlaw?query=' + string[(findStart.end(0))...(findStart.end(0)+findEnd.begin(0))] + '">'
    end 
    return string
  end

  def insert_html_law_modify
    modifies = @article.relationshipmodifies.order(position: :asc)
    browsed = []
    modifies.each do |a|
      if browsed.include? a.position 
        next
      end
      browsed.push(a.position)
      tag = '<a class="article-position" name="' + a.position + '"></a>(.(?!<\/p>))+.<\/p>'
      nxt_post = get_next_post_by_post(a.position)
      nxt_tag = '<a class="article-position" name="' + nxt_post + '"></a>'
      findTag = /#{tag}/m.match(@full_html)
      findNextTag = /#{nxt_tag}/m.match(@full_html)
      if findTag && findNextTag
        @full_html =  @full_html[0,findTag.end(0)] + '<div class="modify-container"><div id="modify-box" class="modify-box-'+ a.position + '">' + @full_html[findTag.end(0),@full_html.length]
        findNextTag = /#{nxt_tag}/m.match(@full_html)
        @full_html =  @full_html[0,findNextTag.begin(0)] + '</div></div>' + @full_html[findNextTag.begin(0),@full_html.length]
      end
      # title = firstStrip(get_title(@article,a.position))
      # modified_law_id = a.modified_law_id
      # html_insert = '<a target="_blank" title="Sửa đổi văn bản" href="/articles/' + modified_law_id + '#'+sumary_to_position(a)+'" class="link_modify"><i class="fa fa-link"></i></a>'
      # if title != nil
      #   pattern = convert2regex(title)
      #   find = /#{pattern}/m.match(@full_html)
      #   if find != nil
      #     @full_html = @full_html[0,find.end(0)] + html_insert + @full_html[find.end(0),@full_html.length]
      #   end
      # end
    end
  end

  def render_law_modify_json
    modifies = @article.relationshipmodifies.order(position: :asc,part_modify_index: :asc,chap_modify_index: :asc,
          sec_modify_index: :asc, law_modify_index: :asc,item_modify_index: :asc,point_modify_index: :asc)
    modifies.each do |m|
      exist = false
      laws = Article.where(id: m.modified_law_id)
      law_modified = nil
      for l in laws
        law_modified = l
        break
      end
      modified_pst = sumary_to_position(m)[0]
      content = nil
      if law_modified
        content = reform_html(get_title(law_modified,modified_pst).to_s)
      end
      modified_law = {
        title: law_modified.article_type + ' ' + law_modified.numerical_symbol,
        id: m.modified_law_id,
        position: modified_pst,
        position_name: sumary_to_position(m)[1],
        content: content
      }
      @modifies_position.each { |modify|
        if (modify[:post] == m.position)
          exist = true
          modified_laws = modify[:modified_laws]
          modified_laws.push(modified_law)
          modify[:modified_content] = modified_laws
        end
      }
      if !exist
        result = {
          post: m.position,
          modified_laws: [modified_law]
        }
        @modifies_position.push(result)
      end
    end
  end

  def insert_html_modified_law
    @reverse_relationshipmodifies = @article.reverse_relationshipmodifies.order(part_modify_index: :asc,chap_modify_index: :asc,
          sec_modify_index: :asc, law_modify_index: :asc,item_modify_index: :asc,point_modify_index: :asc)
    @reverse_relationshipmodifies.each do |a|
      position = sumary_to_position(a)[0]
      law_modifies = Article.where(id: a.law_id)
      law_modify = nil
      for l in law_modifies
        law_modify = l
        break
      end
      content = reform_html(get_title(l,a.position).to_s)
      modify_law = {
        modify_law_title: l.article_type + ' ' + l.numerical_symbol,
        modify_law_id: a.law_id,
        modify_law_pst: a.position,
        content: content,
        modify_law_date: l.public_day.strftime("%d/%m/%Y")
      }
      exist = false
      @modified_position.each { |m|
        if (m[:modified_post] == position)
          exist = true
          modify_laws = m[:modify_laws]
          modify_laws.push(modify_law)
          m[:modify_laws] = modify_laws
        end
      }
      if !exist
        result = {
          modified_post: position,
          nxt_post: get_next_pst(a),
          modify_laws: [modify_law]
        }
        @modified_position.push(result)
      end
    end
  end
  
  def replace_definitions
    defs = Definitionresult.getDef(@full_html)
    for d in defs
      @full_html.gsub!(/#{d.concept}/im)  {|s|  d.sentence + s +'</a>'}
    end
    find = (/data-content=[^\>]+\_[^\>]+/m).match(@full_html)
    while find
      len = find.length
      for i in 1..len
        replace_link = find[i-1].gsub '_', ' ' 
        @full_html = @full_html[0,find.begin(i-1)] + replace_link + @full_html[find.end(i-1),@full_html.length]
        break
      end
      find =  (/data-content=[^\>]+\_[^\>]+/m).match(@full_html)
    end
  end
end