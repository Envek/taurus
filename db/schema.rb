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

ActiveRecord::Schema.define(:version => 20131031061516) do

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buildings", ["name"], :name => "index_buildings_on_name"

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

  add_index "charge_cards", ["assistant_id"], :name => "index_charge_cards_on_assistant_id"
  add_index "charge_cards", ["editor_name"], :name => "index_charge_cards_on_editor_name"
  add_index "charge_cards", ["lesson_type_id"], :name => "index_charge_cards_on_lesson_type_id"
  add_index "charge_cards", ["semester_id"], :name => "index_charge_cards_on_semester_id"
  add_index "charge_cards", ["teaching_place_id"], :name => "index_charge_cards_on_teaching_place_id"

  create_table "charge_cards_disciplines", :force => true do |t|
    t.integer "charge_card_id", :null => false
    t.integer "discipline_id",  :null => false
  end

  add_index "charge_cards_disciplines", ["charge_card_id", "discipline_id"], :name => "charge_cards_disciplines_main_index", :unique => true

  create_table "charge_cards_preferred_classrooms", :id => false, :force => true do |t|
    t.integer "charge_card_id"
    t.integer "classroom_id"
  end

  add_index "charge_cards_preferred_classrooms", ["classroom_id", "charge_card_id"], :name => "preferred_classrooms_main_index", :unique => true

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

  add_index "classrooms", ["building_id"], :name => "index_classrooms_on_building_id"
  add_index "classrooms", ["department_id"], :name => "index_classrooms_on_department_id"
  add_index "classrooms", ["name"], :name => "index_classrooms_on_name"

  create_table "departments", :force => true do |t|
    t.integer  "faculty_id"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gosinsp_code"
    t.integer  "dept_head_id"
  end

  add_index "departments", ["dept_head_id"], :name => "index_departments_on_dept_head_id"
  add_index "departments", ["faculty_id"], :name => "index_departments_on_faculty_id"
  add_index "departments", ["gosinsp_code"], :name => "index_departments_on_gosinsp_code"

  create_table "departments_users", :id => false, :force => true do |t|
    t.integer "department_id"
    t.integer "user_id"
  end

  add_index "departments_users", ["department_id", "user_id"], :name => "department_users_main_index", :unique => true

  create_table "disciplines", :force => true do |t|
    t.integer  "department_id"
    t.string   "short_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "disciplines", ["department_id"], :name => "index_disciplines_on_department_id"
  add_index "disciplines", ["name"], :name => "index_disciplines_on_name"

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

  add_index "faculties", ["name"], :name => "index_faculties_on_name"

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

  add_index "groups", ["forming_year"], :name => "index_groups_on_forming_year"
  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true
  add_index "groups", ["speciality_id"], :name => "index_groups_on_speciality_id"

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

  add_index "jets", ["charge_card_id", "group_id"], :name => "jets_main_index"
  add_index "jets", ["charge_card_id"], :name => "index_jets_on_charge_card_id"
  add_index "jets", ["group_id"], :name => "index_jets_on_group_id"

  create_table "lecturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "whish"
  end

  add_index "lecturers", ["name"], :name => "index_lecturers_on_name"

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

  add_index "pairs", ["charge_card_id"], :name => "index_pairs_on_charge_card_id"
  add_index "pairs", ["classroom_id"], :name => "index_pairs_on_classroom_id"
  add_index "pairs", ["day_of_the_week", "pair_number", "week", "active_at", "expired_at"], :name => "pair_validation_index"

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

  add_index "specialities", ["code"], :name => "index_specialities_on_code"
  add_index "specialities", ["department_id"], :name => "index_specialities_on_department_id"
  add_index "specialities", ["name"], :name => "index_specialities_on_name"

  create_table "subgroups", :force => true do |t|
    t.integer  "jet_id"
    t.integer  "pair_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subgroups", ["jet_id", "pair_id"], :name => "index_subgroups_on_jet_id_and_pair_id", :unique => true
  add_index "subgroups", ["jet_id"], :name => "index_subgroups_on_jet_id"
  add_index "subgroups", ["pair_id"], :name => "index_subgroups_on_pair_id"

  create_table "teaching_places", :force => true do |t|
    t.integer  "department_id"
    t.integer  "lecturer_id"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teaching_places", ["department_id", "lecturer_id"], :name => "teaching_places_main_index", :unique => true
  add_index "teaching_places", ["department_id"], :name => "index_teaching_places_on_department_id"
  add_index "teaching_places", ["lecturer_id"], :name => "index_teaching_places_on_lecturer_id"
  add_index "teaching_places", ["position_id"], :name => "index_teaching_places_on_position_id"

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

  add_index "training_assignments", ["lesson_type_id"], :name => "index_training_assignments_on_lesson_type_id"
  add_index "training_assignments", ["semester_id"], :name => "index_training_assignments_on_semester_id"

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
