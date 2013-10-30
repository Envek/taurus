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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131030162804) do

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charge_cards", :force => true do |t|
    t.integer  "teaching_place_id"
    t.integer  "lesson_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "hours_per_week",    :precision => 5, :scale => 2
    t.integer  "weeks_quantity"
    t.integer  "assistant_id"
    t.string   "editor_name"
    t.integer  "semester_id"
    t.string   "note"
  end

  create_table "charge_cards_disciplines", :force => true do |t|
    t.integer "charge_card_id", :null => false
    t.integer "discipline_id",  :null => false
  end

  add_index "charge_cards_disciplines", ["charge_card_id", "discipline_id"], :name => "charge_cards_disciplines_main_index", :unique => true

  create_table "charge_cards_preferred_classrooms", :id => false, :force => true do |t|
    t.integer "charge_card_id"
    t.integer "classroom_id"
  end

  create_table "classrooms", :force => true do |t|
    t.integer  "building_id"
    t.integer  "department_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity"
    t.boolean  "department_lock", :default => false
    t.string   "title"
    t.hstore   "properties"
  end

  create_table "departments", :force => true do |t|
    t.integer  "faculty_id"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gosinsp_code"
    t.integer  "dept_head_id"
  end

  create_table "departments_users", :id => false, :force => true do |t|
    t.integer "department_id"
    t.integer "user_id"
  end

  create_table "disciplines", :force => true do |t|
    t.integer  "department_id"
    t.string   "short_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disciplines_in_assignments", :id => false, :force => true do |t|
    t.integer "discipline_id"
    t.integer "training_assignment_id"
  end

  add_index "disciplines_in_assignments", ["discipline_id", "training_assignment_id"], :name => "disciplines_in_assignments_uniq_index"

  create_table "faculties", :force => true do |t|
    t.string   "full_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties_users", :id => false, :force => true do |t|
    t.integer "faculty_id", :null => false
    t.integer "user_id",    :null => false
  end

  add_index "faculties_users", ["faculty_id", "user_id"], :name => "faculties_users_main_index", :unique => true

  create_table "groups", :force => true do |t|
    t.integer  "speciality_id"
    t.string   "name"
    t.integer  "forming_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "population"
  end

  create_table "groups_in_assignments", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "training_assignment_id"
  end

  add_index "groups_in_assignments", ["group_id", "training_assignment_id"], :name => "groups_in_assignments_uniq_index"

  create_table "jets", :force => true do |t|
    t.integer  "charge_card_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subgroups_quantity", :default => 0
  end

  create_table "lecturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "whish"
  end

  create_table "lesson_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pairs", :force => true do |t|
    t.integer  "charge_card_id"
    t.integer  "classroom_id"
    t.integer  "timeslot_id"
    t.integer  "day_of_the_week"
    t.integer  "pair_number"
    t.integer  "week"
    t.date     "active_at"
    t.date     "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semesters", :force => true do |t|
    t.integer  "year",                          :null => false
    t.integer  "number",                        :null => false
    t.boolean  "full_time",  :default => true,  :null => false
    t.date     "start"
    t.date     "end"
    t.boolean  "open",       :default => false, :null => false
    t.boolean  "freezed",    :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "published",  :default => false, :null => false
  end

  add_index "semesters", ["year", "number", "full_time"], :name => "index_semesters_on_year_and_number_and_full_time", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specialities", :force => true do |t|
    t.integer  "department_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subgroups", :force => true do |t|
    t.integer  "jet_id"
    t.integer  "pair_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teaching_places", :force => true do |t|
    t.integer  "department_id"
    t.integer  "lecturer_id"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teaching_plans", :force => true do |t|
    t.integer  "speciality_id",                    :null => false
    t.integer  "discipline_id",                    :null => false
    t.integer  "course",                           :null => false
    t.integer  "semester",                         :null => false
    t.integer  "lections"
    t.integer  "practics"
    t.integer  "lab_works"
    t.boolean  "exam",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forming_year",  :default => 2013,  :null => false
  end

  add_index "teaching_plans", ["speciality_id", "discipline_id", "course", "semester", "forming_year"], :name => "teaching_plans_main_index", :unique => true

  create_table "training_assignments", :force => true do |t|
    t.integer  "lesson_type_id"
    t.integer  "weeks_quantity"
    t.integer  "hours"
    t.integer  "semester_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                         :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reset_password_sent_at"
    t.boolean  "admin",                                 :default => false
    t.boolean  "supervisor",                            :default => false
    t.boolean  "editor",                                :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
