# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170808154601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: false, force: :cascade do |t|
    t.text "id"
    t.text "title"
    t.text "content"
    t.text "full_html"
    t.text "index_html"
    t.text "numerical_symbol"
    t.date "public_day"
    t.date "day_report"
    t.text "article_type"
    t.text "source"
    t.text "agency_issued"
    t.text "the_signer"
    t.text "signer_title"
    t.text "scope"
    t.date "effect_day"
    t.text "effect_status"
    t.integer "count_click"
    t.date "created_at"
    t.date "updated_at"
  end

  create_table "chapters", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "part_index"
    t.integer "totalchap"
    t.integer "chap_index"
    t.integer "chap_start"
    t.integer "chap_end"
    t.text "chap_name"
  end

  create_table "extract_modify", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.integer "type"
    t.text "part_modify_name"
    t.text "chap_modify_name"
    t.text "sec_modify_name"
    t.text "law_modify_name"
    t.text "item_modify_name"
    t.text "point_modify_name"
    t.text "text_delete"
    t.text "from_text"
    t.text "to_text"
    t.text "numerical_symbol"
  end

  create_table "header_doc", id: false, force: :cascade do |t|
    t.text "doc_id"
    t.text "header_text"
  end

  create_table "index_modify_position", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.text "modified_law_id"
    t.integer "part_modify_index"
    t.integer "chap_modify_index"
    t.integer "sec_modify_index"
    t.integer "law_modify_index"
    t.integer "item_modify_index"
    t.integer "point_modify_index"
    t.boolean "correct"
  end

  create_table "index_modify_positions", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.text "modified_law_id"
    t.integer "part_modify_index"
    t.integer "chap_modify_index"
    t.integer "sec_modify_index"
    t.integer "law_modify_index"
    t.integer "item_modify_index"
    t.integer "point_modify_index"
    t.boolean "correct"
  end

  create_table "items", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "part_index"
    t.integer "chap_index"
    t.integer "sec_index"
    t.integer "law_index"
    t.integer "totalitem"
    t.integer "item_index"
    t.integer "item_start"
    t.integer "item_end"
    t.text "item_name"
    t.text "item_content"
    t.integer "title_end"
  end

  create_table "law_has_modification", id: false, force: :cascade do |t|
    t.text "doc_id"
    t.text "modyfied_doc_id"
  end

  create_table "laws", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "part_index"
    t.integer "chap_index"
    t.integer "sec_index"
    t.integer "totallaw"
    t.integer "law_index"
    t.integer "law_start"
    t.integer "law_end"
    t.text "law_name"
    t.text "law_content"
    t.integer "title_end"
  end

  create_table "link_modify_articles", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.text "modify_doc_id"
  end

  create_table "parts", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "totalpart"
    t.integer "part_index"
    t.integer "part_start"
    t.integer "part_end"
    t.text "name_part"
  end

  create_table "points", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "part_index"
    t.integer "chap_index"
    t.integer "sec_index"
    t.integer "law_index"
    t.integer "item_index"
    t.integer "totalpoint"
    t.integer "point_index"
    t.integer "point_start"
    t.integer "point_end"
    t.text "point_name"
    t.text "point_content"
  end

  create_table "sections", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "part_index"
    t.integer "chap_index"
    t.integer "totalsec"
    t.integer "sec_index"
    t.integer "sec_start"
    t.integer "sec_end"
    t.text "sec_name"
  end

  create_table "type_modify_law", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "type"
    t.text "doc_content_update"
    t.text "numerical_symbol"
    t.text "position"
  end

  create_table "type_modify_law_0", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "type"
    t.text "doc_content_update"
    t.text "numerical_symbol"
    t.text "position"
  end

  create_table "type_modify_law_1", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "type"
    t.text "doc_content_update"
    t.text "numerical_symbol"
    t.text "position"
  end

  create_table "type_modify_law_2", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "type"
    t.text "doc_content_update"
    t.text "numerical_symbol"
    t.text "position"
  end

end
