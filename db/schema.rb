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

ActiveRecord::Schema.define(version: 20140714143047) do

  create_table "attachements", force: true do |t|
    t.string   "title"
    t.integer  "lunchlearn_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "title"
    t.integer  "lunchlearn_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "attendees", force: true do |t|
    t.integer  "user_id"
    t.integer  "lunchlearn_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", force: true do |t|
    t.integer  "user_id"
    t.integer  "lunchlearn_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lunchlearns", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "lunch_date"
    t.time     "lunch_time"
    t.string   "meeting_phone_number"
    t.string   "access_code"
    t.boolean  "has_GoToMeeting"
    t.string   "go_to_meeting_url"
    t.time     "end_time"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions", force: true do |t|
    t.integer  "user_id"
    t.string   "suggestion_title"
    t.string   "suggestion_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.string   "photo"
    t.string   "email"
  end

end
