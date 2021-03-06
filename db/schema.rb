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

ActiveRecord::Schema.define(version: 20160511054912) do

  create_table "event_users", force: :cascade do |t|
    t.integer  "attendee_user_id", limit: 4
    t.integer  "event_id",         limit: 4
    t.boolean  "absent"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "event_users", ["attendee_user_id"], name: "index_event_users_on_attendee_user_id", using: :btree
  add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "capacity",    limit: 4
    t.string   "location",    limit: 255
    t.integer  "owner_id",    limit: 4
    t.string   "owner",       limit: 255
    t.text     "description", limit: 65535
    t.datetime "hold_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "events", ["hold_at"], name: "index_events_on_hold_at", using: :btree
  add_index "events", ["owner_id"], name: "index_events_on_owner_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",    limit: 255
    t.integer  "uid",         limit: 4
    t.string   "name",        limit: 255
    t.string   "nickname",    limit: 255
    t.string   "image",       limit: 255
    t.text     "description", limit: 65535
    t.string   "token",       limit: 255
    t.string   "secret",      limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

end
