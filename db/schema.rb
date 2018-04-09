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

ActiveRecord::Schema.define(version: 20180422070203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposit_histories", force: :cascade do |t|
    t.bigint "money_account_id"
    t.integer "ammount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["money_account_id"], name: "index_deposit_histories_on_money_account_id"
  end

  create_table "lawyer_specializes", force: :cascade do |t|
    t.bigint "lawyer_id"
    t.bigint "specialization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lawyer_id", "specialization_id"], name: "index_lawyer_specializes_on_lawyer_id_and_specialization_id", unique: true
    t.index ["lawyer_id"], name: "index_lawyer_specializes_on_lawyer_id"
    t.index ["specialization_id"], name: "index_lawyer_specializes_on_specialization_id"
  end

  create_table "lawyers", force: :cascade do |t|
    t.string "user_id"
    t.text "achievement"
    t.string "cardNumber"
    t.string "certificate"
    t.text "education"
    t.text "intro"
    t.integer "price"
    t.integer "exp"
    t.float "rate"
    t.text "workPlace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lawyers_on_user_id"
  end

  create_table "money_accounts", force: :cascade do |t|
    t.bigint "profile_id"
    t.integer "ammount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_money_accounts_on_profile_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "room_id"
    t.datetime "startTime"
    t.datetime "endTime"
    t.integer "ammount"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_payments_on_room_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "user_id"
    t.string "userName"
    t.string "displayName"
    t.string "avatar"
    t.datetime "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["userName"], name: "index_profiles_on_userName", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "user_id", null: false
    t.bigint "lawyer_id", null: false
    t.text "content"
    t.float "star", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lawyer_id"], name: "index_reviews_on_lawyer_id"
    t.index ["user_id", "lawyer_id"], name: "index_reviews_on_user_id_and_lawyer_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", id: :string, force: :cascade do |t|
    t.bigint "lawyer_id"
    t.string "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lawyer_id"], name: "index_rooms_on_lawyer_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "room_id"
    t.text "content"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_tasks_on_room_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "status", default: "online"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "deposit_histories", "money_accounts"
  add_foreign_key "lawyer_specializes", "lawyers"
  add_foreign_key "lawyer_specializes", "specializations"
  add_foreign_key "lawyers", "users"
  add_foreign_key "money_accounts", "profiles"
  add_foreign_key "payments", "rooms"
  add_foreign_key "profiles", "users"
  add_foreign_key "reviews", "lawyers"
  add_foreign_key "reviews", "users"
  add_foreign_key "rooms", "lawyers"
  add_foreign_key "rooms", "users"
  add_foreign_key "tasks", "rooms"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
