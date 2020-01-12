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

ActiveRecord::Schema.define(version: 2020_01_10_020340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street_address", default: "", null: false
    t.string "street_address_2", default: "", null: false
    t.string "postal_code", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city", default: "", null: false
    t.string "state", default: "", null: false
    t.string "country", default: "", null: false
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "call_applications", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "user_id", null: false
    t.text "artist_statement", default: "", null: false
    t.string "artist_website", default: "", null: false
    t.string "artist_instagram_url", default: "", null: false
    t.string "photos_url", default: "", null: false
    t.string "supplemental_material_url", default: "", null: false
    t.integer "status_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creation_status", default: 0, null: false
    t.bigint "category_id"
    t.index ["call_id", "user_id"], name: "index_call_applications_on_call_id_and_user_id", unique: true
    t.index ["call_id"], name: "index_call_applications_on_call_id"
    t.index ["category_id"], name: "index_call_applications_on_category_id"
    t.index ["user_id"], name: "index_call_applications_on_user_id"
  end

  create_table "call_categories", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id", "category_id"], name: "index_call_categories_on_call_id_and_category_id", unique: true
    t.index ["call_id"], name: "index_call_categories_on_call_id"
    t.index ["category_id"], name: "index_call_categories_on_category_id"
  end

  create_table "call_category_users", force: :cascade do |t|
    t.bigint "call_category_id", null: false
    t.bigint "call_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_category_id", "call_user_id"], name: "index_call_category_users_on_call_category_id_and_call_user_id", unique: true
    t.index ["call_category_id"], name: "index_call_category_users_on_call_category_id"
    t.index ["call_user_id"], name: "index_call_category_users_on_call_user_id"
  end

  create_table "call_users", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id", "user_id"], name: "index_call_users_on_call_id_and_user_id", unique: true
    t.index ["call_id"], name: "index_call_users_on_call_id"
    t.index ["user_id"], name: "index_call_users_on_user_id"
  end

  create_table "calls", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "venue_id"
    t.date "start_at"
    t.date "end_at"
    t.string "overview", default: "", null: false
    t.text "full_description", default: "", null: false
    t.datetime "application_deadline", null: false
    t.text "application_details", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: false, null: false
    t.bigint "user_id", null: false
    t.boolean "is_approved", default: false, null: false
    t.boolean "external", default: false, null: false
    t.string "external_url", default: "", null: false
    t.integer "view_count", default: 0, null: false
    t.integer "call_type_id", null: false
    t.integer "eligibility", default: 1, null: false
    t.integer "entry_fee"
    t.integer "spider", default: 0, null: false
    t.index ["call_type_id"], name: "index_calls_on_call_type_id"
    t.index ["user_id"], name: "index_calls_on_user_id"
    t.index ["venue_id"], name: "index_calls_on_venue_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "chat_users", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "user_id"], name: "index_chat_users_on_chat_id_and_user_id", unique: true
    t.index ["chat_id"], name: "index_chat_users_on_chat_id"
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.string "chatworthy_type", default: "", null: false
    t.bigint "chatworthy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatworthy_type", "chatworthy_id"], name: "index_chats_on_chatworthy_type_and_chatworthy_id", unique: true
  end

  create_table "connections", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.index ["user1_id", "user2_id"], name: "index_connections_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_connections_on_user1_id"
    t.index ["user2_id"], name: "index_connections_on_user2_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_user_id", null: false
    t.text "body", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_user_id"], name: "index_messages_on_chat_user_id"
  end

  create_table "piece_images", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.string "alt", default: "", null: false
    t.bigint "piece_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["piece_id", "position"], name: "index_piece_images_on_piece_id_and_position", unique: true
    t.index ["piece_id"], name: "index_piece_images_on_piece_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.string "title", default: ""
    t.bigint "user_id", null: false
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "medium", default: "", null: false
    t.bigint "call_application_id"
    t.index ["call_application_id"], name: "index_pieces_on_call_application_id"
    t.index ["user_id"], name: "index_pieces_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", default: "en", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.boolean "is_artist", default: false, null: false
    t.boolean "is_curator", default: false, null: false
    t.string "artist_website", default: "", null: false
    t.string "instagram_url", default: "", null: false
    t.string "gravatar_url", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.text "artist_statement", default: "", null: false
    t.text "bio", default: "", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "website", default: "", null: false
    t.bigint "address_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_venues_on_address_id"
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "call_applications", "calls"
  add_foreign_key "call_applications", "categories"
  add_foreign_key "call_applications", "users"
  add_foreign_key "call_categories", "calls"
  add_foreign_key "call_categories", "categories"
  add_foreign_key "call_category_users", "call_categories"
  add_foreign_key "call_category_users", "call_users"
  add_foreign_key "call_users", "calls"
  add_foreign_key "call_users", "users"
  add_foreign_key "calls", "users"
  add_foreign_key "calls", "venues"
  add_foreign_key "connections", "users", column: "user1_id"
  add_foreign_key "connections", "users", column: "user2_id"
  add_foreign_key "piece_images", "pieces"
  add_foreign_key "pieces", "call_applications"
  add_foreign_key "pieces", "users"
  add_foreign_key "venues", "addresses"
  add_foreign_key "venues", "users"
end
