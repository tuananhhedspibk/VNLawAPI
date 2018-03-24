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

ActiveRecord::Schema.define(version: 20180305154945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_neighbors", force: :cascade do |t|
    t.string "source_id"
    t.string "neighbor_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neighbor_id"], name: "index_article_neighbors_on_neighbor_id"
    t.index ["source_id", "neighbor_id"], name: "index_article_neighbors_on_source_id_and_neighbor_id", unique: true
    t.index ["source_id"], name: "index_article_neighbors_on_source_id"
  end

  create_table "article_topics", force: :cascade do |t|
    t.text "article_id"
    t.text "topics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_topics_on_article_id"
  end

  create_table "articles", id: :text, force: :cascade do |t|
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

  create_table "content_phrases_0", id: false, force: :cascade do |t|
    t.text "doc_id"
    t.text "content"
  end

  create_table "content_phrases_1", id: false, force: :cascade do |t|
    t.text "doc_id"
    t.text "content"
  end

  create_table "dd_factors_inf_istrue_has_definition_0", id: false, force: :cascade do |t|
    t.bigint "has_definition.R0.dd_id"
    t.float "feature_value"
    t.integer "pid"
  end

  create_table "dd_factors_inf_istrue_has_definition_1", id: false, force: :cascade do |t|
    t.bigint "has_definition.R0.dd_id"
    t.float "feature_value"
    t.integer "pid"
  end

  create_table "dd_factors_inf_istrue_has_definition_2", id: false, force: :cascade do |t|
    t.bigint "has_definition.R0.dd_id"
    t.text "dd_weight_column_0"
    t.float "feature_value"
    t.integer "pid"
  end

  create_table "dd_graph_variables_holdout", primary_key: "variable_id", id: :bigint, default: nil, force: :cascade do |t|
  end

  create_table "dd_graph_variables_observation", primary_key: "variable_id", id: :bigint, default: nil, force: :cascade do |t|
  end

  create_table "dd_inference_result_variables", id: false, force: :cascade do |t|
    t.bigint "vid"
    t.bigint "cid"
    t.float "prb"
  end

  create_table "dd_inference_result_weights", primary_key: "wid", id: :bigint, default: nil, force: :cascade do |t|
    t.float "weight"
  end

  create_table "dd_variables_has_definition", id: false, force: :cascade do |t|
    t.text "mention_id"
    t.boolean "dd__label"
    t.bigint "dd__count"
    t.integer "dd__part"
    t.bigint "dd_id"
  end

  create_table "dd_variables_with_id_has_definition", id: false, force: :cascade do |t|
    t.text "mention_id"
    t.boolean "dd_label"
    t.decimal "dd_truthiness"
    t.bigint "dd_id"
    t.integer "dd__part"
  end

  create_table "dd_weights_inf_istrue_has_definition_0", id: false, force: :cascade do |t|
    t.boolean "isfixed"
    t.integer "initvalue"
    t.bigint "wid"
  end

  create_table "dd_weights_inf_istrue_has_definition_1", id: false, force: :cascade do |t|
    t.boolean "isfixed"
    t.integer "initvalue"
    t.bigint "wid"
  end

  create_table "dd_weights_inf_istrue_has_definition_2", id: false, force: :cascade do |t|
    t.text "dd_weight_column_0"
    t.boolean "isfixed"
    t.integer "initvalue"
    t.bigint "wid"
  end

  create_table "definition_features", id: false, force: :cascade do |t|
    t.text "mention_id"
    t.text "feature"
  end

  create_table "definition_label__0", id: false, force: :cascade do |t|
    t.text "mention_id"
    t.integer "label"
    t.text "rule_id"
  end

  create_table "definition_mention", id: false, force: :cascade do |t|
    t.text "mention_id"
    t.text "law_id"
    t.text "position"
    t.integer "sentence_index"
    t.text "concept_expression"
    t.integer "begin_exp"
    t.integer "end_exp"
    t.text "explain_text"
    t.integer "begin_explain"
    t.integer "end_explain"
  end

  create_table "definitionresults", id: false, force: :cascade do |t|
    t.text "concept"
    t.boolean "dd_label"
    t.float "expectation"
    t.text "law_id"
    t.text "sentence"
    t.boolean "global_def"
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

  create_table "lawyer_specializes", force: :cascade do |t|
    t.bigint "lawyer_id"
    t.bigint "specialization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lawyer_id"], name: "index_lawyer_specializes_on_lawyer_id"
    t.index ["specialization_id"], name: "index_lawyer_specializes_on_specialization_id"
  end

  create_table "lawyers", force: :cascade do |t|
    t.string "name"
    t.string "fb_id", default: ""
    t.string "photo_url", default: ""
    t.float "rate", default: 0.0
    t.text "intro", default: ""
    t.integer "cost", default: 0
    t.integer "view_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", id: false, force: :cascade do |t|
    t.text "law_id"
    t.integer "totalpart"
    t.integer "part_index"
    t.integer "part_start"
    t.integer "part_end"
    t.text "name_part"
  end

  create_table "payments", force: :cascade do |t|
    t.string "uid"
    t.string "refcode"
    t.boolean "done"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phrases", id: false, force: :cascade do |t|
    t.text "doc_id"
    t.text "phrases"
    t.text "pos_tag", array: true
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

  create_table "sentence_0", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.integer "sentence_index"
    t.text "sentence_text"
    t.text "tokens", array: true
    t.text "pos_tags", array: true
  end

  create_table "sentence_1", id: false, force: :cascade do |t|
    t.text "law_id"
    t.text "position"
    t.integer "sentence_index"
    t.text "sentence_text"
    t.text "tokens", array: true
    t.text "pos_tags", array: true
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "article_topics", "articles"
  add_foreign_key "lawyer_specializes", "lawyers"
  add_foreign_key "lawyer_specializes", "specializations"
end
