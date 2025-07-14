# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_14_075432) do
  create_table "contents", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.string "age_rating", default: "adult"
    t.integer "organization_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_rating"], name: "index_contents_on_age_rating"
    t.index ["created_at"], name: "index_contents_on_created_at"
    t.index ["organization_id", "age_rating"], name: "index_contents_on_organization_id_and_age_rating"
    t.index ["organization_id"], name: "index_contents_on_organization_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "organization_analytics", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "metric_name"
    t.decimal "metric_value"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_analytics_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "min_age", default: 0
    t.integer "max_age", default: 120
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
  end

  create_table "user_organizations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.string "role", default: "member"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_user_organizations_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.boolean "parental_consent", default: true
    t.string "age_group", default: "adult"
    t.index ["age_group"], name: "index_users_on_age_group"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contents", "organizations"
  add_foreign_key "contents", "users"
  add_foreign_key "organization_analytics", "organizations"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
end
