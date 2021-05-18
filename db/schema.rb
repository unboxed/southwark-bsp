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

ActiveRecord::Schema.define(version: 2021_05_18_172908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "building_survey_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "building_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id", "most_recent"], name: "index_building_survey_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["building_id", "sort_key"], name: "index_building_survey_transitions_parent_sort", unique: true
  end

  create_table "buildings", force: :cascade do |t|
    t.string "building_name"
    t.string "uprn"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "street"
    t.string "city_town"
    t.string "postcode"
    t.citext "proprietor_email"
    t.string "land_registry_title_number"
    t.string "land_registry_proprietor_name"
    t.string "land_registry_proprietor_address"
    t.string "land_registry_proprietor_category"
    t.string "land_registry_proprietor_company_registration_number"
    t.boolean "on_delta", default: false
    t.index ["uprn"], name: "index_buildings_on_uprn", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.string "notification_mean", default: "", null: false
    t.string "state", default: "created", null: false
    t.datetime "enqueued_at"
    t.datetime "sent_at"
    t.datetime "delivered_at"
    t.datetime "failed_at"
    t.string "notify_id"
    t.string "notify_uri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id"], name: "index_notifications_on_building_id"
  end

  create_table "survey_records", force: :cascade do |t|
    t.bigint "building_id"
    t.string "session_id", null: false
    t.string "stage", limit: 50, default: "uprn", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "completed_at"
    t.datetime "submitted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.index ["building_id"], name: "index_survey_records_on_building_id"
    t.index ["session_id"], name: "index_survey_records_on_session_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "building_survey_transitions", "buildings"
  add_foreign_key "notifications", "buildings"
  add_foreign_key "survey_records", "buildings"
end
