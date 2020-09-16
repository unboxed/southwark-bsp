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

ActiveRecord::Schema.define(version: 2020_09_16_132752) do

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

  create_table "building_ownerships", force: :cascade do |t|
    t.integer "ownership_status"
    t.bigint "survey_id", null: false
    t.text "ownership_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "right_to_manage_company"
    t.string "full_name"
    t.string "email"
    t.string "organisation"
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

  create_table "building_walls", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.integer "material_quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_building_walls_on_survey_id"
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
    t.index ["uprn"], name: "index_buildings_on_uprn", unique: true
  end

  create_table "material_detail_lists", force: :cascade do |t|
    t.bigint "building_external_wall_structure_id", null: false
    t.string "external_structure_name", default: "", null: false
    t.boolean "has_timber_or_wood_primary_material", default: false, null: false
    t.boolean "has_timber_or_wood_floor_material", default: false, null: false
    t.boolean "has_timber_or_wood_railing_material", default: false, null: false
    t.boolean "has_glass_primary_material", default: false, null: false
    t.boolean "has_glass_floor_material", default: false, null: false
    t.boolean "has_glass_railing_material", default: false, null: false
    t.boolean "has_metal_primary_material", default: false, null: false
    t.boolean "has_metal_floor_material", default: false, null: false
    t.boolean "has_metal_railing_material", default: false, null: false
    t.boolean "has_concrete_primary_material", default: false, null: false
    t.boolean "has_concrete_floor_material", default: false, null: false
    t.boolean "has_concrete_railing_material", default: false, null: false
    t.boolean "has_unknown_primary_material", default: false, null: false
    t.boolean "has_unknown_floor_material", default: false, null: false
    t.boolean "has_unknown_railing_material", default: false, null: false
    t.boolean "has_other_primary_material", default: false, null: false
    t.boolean "has_other_floor_material", default: false, null: false
    t.boolean "has_other_railing_material", default: false, null: false
    t.string "other_primary_material_details"
    t.string "other_floor_material_details"
    t.string "other_railing_material_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_external_wall_structure_id"], name: "index_detail_list_on_wall_structure_id"
  end

  create_table "materials", force: :cascade do |t|
    t.bigint "building_wall_id", null: false
    t.string "name"
    t.text "details"
    t.integer "percentage"
    t.string "insulation_material"
    t.text "insulation_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_wall_id"], name: "index_materials_on_building_wall_id"
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
    t.string "reference_id"
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
  add_foreign_key "building_walls", "surveys"
  add_foreign_key "material_detail_lists", "building_external_wall_structures"
  add_foreign_key "materials", "building_walls"
  add_foreign_key "sections", "surveys"
  add_foreign_key "surveys", "buildings"
end
