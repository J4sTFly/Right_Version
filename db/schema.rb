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

ActiveRecord::Schema[7.0].define(version: 2022_05_22_010039) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "news_id"
    t.bigint "user_id"
    t.bigint "parent_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_id"], name: "index_comments_on_news_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.integer "available_to", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.text "abstract"
    t.text "body"
    t.string "location"
    t.datetime "added"
    t.datetime "published_at"
    t.boolean "important", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.boolean "approved", default: false, null: false
    t.float "avg_rate", default: 0.0
    t.bigint "category_id"
    t.index ["author_id"], name: "index_news_on_author_id"
    t.index ["available_to"], name: "index_news_on_available_to"
    t.index ["category_id"], name: "index_news_on_category_id"
    t.index ["important"], name: "index_news_on_important"
    t.index ["status"], name: "index_news_on_status"
  end

  create_table "news_tags", id: false, force: :cascade do |t|
    t.bigint "news_id", null: false
    t.bigint "tag_id", null: false
    t.index ["news_id"], name: "index_news_tags_on_news_id"
    t.index ["tag_id"], name: "index_news_tags_on_tag_id"
  end

  create_table "news_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "news_id", null: false
    t.index ["news_id"], name: "index_news_users_on_news_id"
    t.index ["user_id"], name: "index_news_users_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.float "rate", null: false
    t.bigint "news_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_id"], name: "index_rates_on_news_id"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "username", null: false
    t.string "name"
    t.string "bio"
    t.string "phone", default: "", null: false
    t.string "country"
    t.integer "role", default: 0
    t.string "jti"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "news"
  add_foreign_key "comments", "users"
  add_foreign_key "news", "categories"
  add_foreign_key "rates", "news"
  add_foreign_key "rates", "users"
end
