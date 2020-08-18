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

ActiveRecord::Schema.define(version: 2020_08_18_173959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "building_managers", force: :cascade do |t|
    t.citext "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_building_managers_on_email"
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
    t.bigint "survey_id", null: false
    t.integer "tenure_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_tenures_on_survey_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "manager_id", null: false
    t.index ["manager_id"], name: "index_buildings_on_manager_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id"], name: "index_surveys_on_building_id"
  end

  add_foreign_key "building_statuses", "surveys"
  add_foreign_key "building_tenures", "surveys"
  add_foreign_key "buildings", "building_managers", column: "manager_id"
  add_foreign_key "surveys", "buildings"
end
