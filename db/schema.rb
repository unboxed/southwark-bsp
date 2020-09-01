# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_27_102932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "building_external_wall_structures", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.boolean "has_balconies", default: false, null: false
    t.boolean "has_solar_shading", default: false, null: false
    t.boolean "has_green_walls", default: false, null: false
    t.boolean "has_no_external_structures", default: false, null: false
    t.boolean "has_other_structure", default: false, null: false
    t.string "other_structure_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_external_wall_structures_on_survey_id"
  end

  create_table "building_heights", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.boolean "higher_than_18_meters"
    t.integer "height_in_meters"
    t.integer "height_in_storeys"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_heights_on_survey_id"
  end

  create_table "building_managers", force: :cascade do |t|
    t.citext "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_building_managers_on_email"
  end

  create_table "building_ownerships", force: :cascade do |t|
    t.integer "ownership_status"
    t.bigint "survey_id", null: false
    t.text "ownership_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_ownerships_on_survey_id"
  end

  create_table "building_statuses", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.integer "status", default: 0, null: false
    t.text "status_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_statuses_on_survey_id"
  end

  create_table "building_tenures", force: :cascade do |t|
    t.integer "tenure_type"
    t.bigint "survey_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_tenures_on_survey_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "address", null: false
    t.bigint "UPRN"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "manager_id"
    t.index ["manager_id"], name: "index_buildings_on_manager_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.string "content_type"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_sections_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id"], name: "index_surveys_on_building_id"
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

  add_foreign_key "building_external_wall_structures", "surveys"
  add_foreign_key "building_heights", "surveys"
  add_foreign_key "building_ownerships", "surveys"
  add_foreign_key "building_statuses", "surveys"
  add_foreign_key "building_tenures", "surveys"
  add_foreign_key "buildings", "building_managers", column: "manager_id"
  add_foreign_key "sections", "surveys"
  add_foreign_key "surveys", "buildings"
end
