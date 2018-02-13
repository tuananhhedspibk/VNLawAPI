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

ActiveRecord::Schema.define(version: 20180212151527) do

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

  create_table "articles", force: :cascade do |t|
    t.string "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles_topics", force: :cascade do |t|
    t.integer "article_id"
    t.text "topics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "lawyer_specializes", "lawyers"
  add_foreign_key "lawyer_specializes", "specializations"
end
