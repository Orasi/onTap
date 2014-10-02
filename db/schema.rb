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

ActiveRecord::Schema.define(version: 201407231923422322432) do

  create_table "attachments", force: true do |t|
    t.string   "title"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "direct_upload_url"
    t.string   "processed"
  end

  create_table "attendees", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "event_styles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "element_id"
    t.string   "element_type"
  end

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "description"
    t.boolean  "restricted"
    t.string   "status"
    t.date     "finalized_date"
  end

  create_table "hosts", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "external"
    t.string   "host"
  end

  create_table "lunchlearns", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meeting_phone_number"
    t.string   "access_code"
    t.boolean  "has_GoToMeeting"
    t.string   "go_to_meeting_url"
  end

  create_table "notifications", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "manager_id"
    t.string   "status"
    t.string   "notification_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.date     "event_date"
    t.time     "event_time"
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

  create_table "surveys", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "went_well"
    t.text     "improved"
    t.integer  "host_knowledge"
    t.integer  "host_presentation"
    t.text     "effect"
    t.text     "extra"
  end

  create_table "training_classes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "webinars", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

end
