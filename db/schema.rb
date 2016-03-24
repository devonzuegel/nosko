# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160324171930) do

  create_table "articles", force: :cascade do |t|
    t.integer  "permalink_id", null: false
    t.string   "url"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "evernote_accounts", force: :cascade do |t|
    t.string  "auth_token"
    t.integer "user_id"
  end

  add_index "evernote_accounts", ["user_id"], name: "index_evernote_accounts_on_user_id"

  create_table "highlights", force: :cascade do |t|
    t.integer  "article_id",   null: false
    t.integer  "permalink_id", null: false
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "highlights", ["article_id"], name: "index_highlights_on_article_id"

  create_table "permalinks", force: :cascade do |t|
    t.text     "path",                       null: false
    t.boolean  "publicized", default: false
    t.boolean  "trashed",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "sharings", force: :cascade do |t|
    t.boolean  "share_by_default",    default: false
    t.string   "reminders_frequency", default: "daily"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "sharings", ["user_id"], name: "index_sharings_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
