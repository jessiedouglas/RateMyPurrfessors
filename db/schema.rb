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

ActiveRecord::Schema.define(version: 20141029134424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colleges", force: true do |t|
    t.string   "name",       null: false
    t.string   "location",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "professor_ratings", force: true do |t|
    t.integer  "professor_id",                            null: false
    t.integer  "rater_id",                                null: false
    t.string   "course_code",                             null: false
    t.boolean  "online_class",            default: false
    t.integer  "helpfulness",                             null: false
    t.integer  "clarity",                                 null: false
    t.integer  "easiness",                                null: false
    t.boolean  "taken_for_credit",        default: true
    t.boolean  "hotness",                 default: false
    t.text     "comments"
    t.boolean  "attendance_is_mandatory", default: false
    t.integer  "interest"
    t.integer  "textbook_use"
    t.string   "grade_received",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "professor_ratings", ["professor_id", "rater_id"], name: "index_professor_ratings_on_professor_id_and_rater_id", unique: true, using: :btree
  add_index "professor_ratings", ["professor_id"], name: "index_professor_ratings_on_professor_id", using: :btree
  add_index "professor_ratings", ["rater_id"], name: "index_professor_ratings_on_rater_id", using: :btree

  create_table "professors", force: true do |t|
    t.string   "first_name",     null: false
    t.string   "middle_initial"
    t.string   "last_name",      null: false
    t.integer  "college_id",     null: false
    t.string   "department",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "professors", ["college_id"], name: "index_professors_on_college_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "session_token",   null: false
    t.string   "password_digest", null: false
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "college_id",      null: false
  end

  add_index "users", ["college_id"], name: "index_users_on_college_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["session_token"], name: "index_users_on_session_token", unique: true, using: :btree

end
