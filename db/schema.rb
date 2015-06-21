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

ActiveRecord::Schema.define(version: 20150515114058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "where"
    t.boolean  "active",        default: true
    t.string   "event_type"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "reminder_time"
    t.integer  "wday"
  end

  add_index "events", ["active"], name: "index_events_on_active", using: :btree
  add_index "events", ["event_type"], name: "index_events_on_event_type", using: :btree
  add_index "events", ["reminder_time"], name: "index_events_on_reminder_time", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "events_reminders", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "reminder_id"
  end

  add_index "events_reminders", ["event_id"], name: "index_events_reminders_on_event_id", using: :btree
  add_index "events_reminders", ["reminder_id"], name: "index_events_reminders_on_reminder_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "log_type"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "reminder_id"
    t.text     "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "logs", ["event_id"], name: "index_logs_on_event_id", using: :btree
  add_index "logs", ["log_type"], name: "index_logs_on_log_type", using: :btree
  add_index "logs", ["reminder_id"], name: "index_logs_on_reminder_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "reminder_type"
    t.string   "identifier"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "verified",           default: false
    t.string   "verification_token"
  end

  add_index "reminders", ["reminder_type"], name: "index_reminders_on_reminder_type", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree
  add_index "reminders", ["verification_token"], name: "index_reminders_on_verification_token", using: :btree
  add_index "reminders", ["verified"], name: "index_reminders_on_verified", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "time_zone"
    t.boolean  "is_admin",               default: false
    t.string   "oneall_token"
    t.boolean  "nopasswd",               default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["oneall_token"], name: "index_users_on_oneall_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
