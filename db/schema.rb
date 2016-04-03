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

ActiveRecord::Schema.define(version: 20160403080010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "permalink_id", null: false
    t.string   "title"
    t.string   "source_url",   null: false
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "evernote_accounts", force: :cascade do |t|
    t.string   "auth_token"
    t.datetime "last_accessed_at"
    t.integer  "user_id"
  end

  add_index "evernote_accounts", ["user_id"], name: "index_evernote_accounts_on_user_id", using: :btree

  create_table "evernote_extractors", force: :cascade do |t|
    t.string   "guid"
    t.datetime "last_accessed_at"
    t.integer  "evernote_account_id"
    t.integer  "article_id"
  end

  add_index "evernote_extractors", ["article_id"], name: "index_evernote_extractors_on_article_id", using: :btree
  add_index "evernote_extractors", ["evernote_account_id"], name: "index_evernote_extractors_on_evernote_account_id", using: :btree

  create_table "highlights", force: :cascade do |t|
    t.integer  "article_id",   null: false
    t.integer  "permalink_id", null: false
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "highlights", ["article_id"], name: "index_highlights_on_article_id", using: :btree

  create_table "permalinks", force: :cascade do |t|
    t.text     "path",                       null: false
    t.boolean  "publicized", default: false
    t.boolean  "trashed",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "que_jobs", id: false, force: :cascade do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
    t.text     "queue",                 default: "",                                         null: false
  end

  create_table "sharings", force: :cascade do |t|
    t.boolean  "share_by_default",    default: false
    t.string   "reminders_frequency", default: "daily"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "sharings", ["user_id"], name: "index_sharings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "articles", "permalinks"
  add_foreign_key "evernote_accounts", "users"
  add_foreign_key "evernote_extractors", "articles"
  add_foreign_key "evernote_extractors", "evernote_accounts"
  add_foreign_key "highlights", "articles"
  add_foreign_key "highlights", "permalinks"
  add_foreign_key "sharings", "users"
end
