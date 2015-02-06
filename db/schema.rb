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

ActiveRecord::Schema.define(version: 20140304144200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acceptance_criteria", force: :cascade do |t|
    t.string  "detail"
    t.integer "user_story_id"
    t.integer "version"
    t.boolean "done",          default: false
    t.integer "position"
  end

  add_index "acceptance_criteria", ["user_story_id", "position"], name: "index_acceptance_criteria_on_user_story_id_and_position", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "time_zone"
    t.integer  "account_holder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_length"
    t.string   "subdomain"
    t.integer  "velocity"
  end

  create_table "beta_emails", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "burndowns", force: :cascade do |t|
    t.integer "sprint_id"
    t.integer "hours_left"
    t.date    "created_on"
    t.integer "story_points_complete"
    t.integer "story_points_remaining"
  end

  add_index "burndowns", ["sprint_id", "created_on"], name: "index_burndowns_on_sprint_id_and_created_on", unique: true, using: :btree
  add_index "burndowns", ["sprint_id"], name: "index_burndowns_on_sprint_id", using: :btree

  create_table "hip_chat_integrations", force: :cascade do |t|
    t.string  "room"
    t.string  "token"
    t.boolean "notify",     default: false
    t.integer "project_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "email",                  null: false
    t.integer  "project_id"
    t.integer  "sent_count", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "invitations", ["email", "project_id"], name: "index_invitations_on_email_and_project_id", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "account_id"
    t.integer  "authenticated",                     default: 0
    t.string   "activation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_type"
    t.string   "hashed_password",        limit: 40
    t.string   "salt",                   limit: 40
    t.string   "api_key"
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "deleted_at"
    t.string   "unsubscribe_token"
  end

  add_index "people", ["account_id", "api_key", "authenticated", "activation_code"], name: "by_api_key", using: :btree
  add_index "people", ["authentication_token"], name: "index_people_on_authentication_token", unique: true, using: :btree
  add_index "people", ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true, using: :btree
  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  add_index "people", ["unsubscribe_token"], name: "index_people_on_unsubscribe_token", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",             null: false
    t.integer  "iteration_length"
    t.integer  "velocity"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "deleted_at"
  end

  add_index "projects", ["name"], name: "index_projects_on_name", unique: true, using: :btree

  create_table "slack_integrations", force: :cascade do |t|
    t.string  "team"
    t.string  "channel"
    t.string  "token"
    t.integer "project_id"
  end

  create_table "sprint_elements", force: :cascade do |t|
    t.integer "sprint_id"
    t.integer "user_story_id"
    t.integer "position"
    t.integer "version"
  end

  add_index "sprint_elements", ["sprint_id", "position"], name: "index_sprint_elements_on_sprint_id_and_position", using: :btree
  add_index "sprint_elements", ["user_story_id", "sprint_id"], name: "index_sprint_elements_on_user_story_id_and_sprint_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.integer  "account_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "goal"
    t.string   "name"
    t.integer  "velocity"
    t.integer  "project_id"
  end

  add_index "sprints", ["id", "project_id", "start_at"], name: "index_sprints_on_id_and_project_id_and_start_at", order: {"start_at"=>:desc}, using: :btree
  add_index "sprints", ["project_id", "start_at"], name: "index_sprints_on_project_id_and_start_at", order: {"start_at"=>:desc}, using: :btree
  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree

  create_table "task_developers", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_developers", ["task_id"], name: "index_task_developers_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "definition"
    t.text     "description"
    t.boolean  "done",          default: false
    t.integer  "position"
    t.integer  "developer_id"
    t.integer  "user_story_id"
    t.integer  "version"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "tasks", ["user_story_id", "done"], name: "index_tasks_on_user_story_id_and_done", using: :btree
  add_index "tasks", ["user_story_id"], name: "index_tasks_on_user_story_id", using: :btree

  create_table "team_members", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.boolean  "scrum_master",    default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "deleted_at"
    t.boolean  "notify_by_email", default: false
  end

  add_index "team_members", ["project_id", "person_id"], name: "index_team_members_on_project_id_and_person_id", using: :btree
  add_index "team_members", ["project_id"], name: "index_team_members_on_project_id", using: :btree

  create_table "user_stories", force: :cascade do |t|
    t.text     "definition"
    t.text     "description"
    t.integer  "story_points"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_id"
    t.integer  "account_id"
    t.integer  "version"
    t.integer  "person_id"
    t.integer  "cannot_be_estimated", default: 0
    t.string   "stakeholder",         default: ""
    t.boolean  "delta",               default: false
    t.integer  "project_id"
  end

  add_index "user_stories", ["project_id", "sprint_id"], name: "index_user_stories_on_project_id_and_sprint_id", using: :btree
  add_index "user_stories", ["project_id"], name: "index_user_stories_on_project_id", using: :btree

end
