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

ActiveRecord::Schema.define(:version => 20130217122349) do

  create_table "acceptance_criteria", :force => true do |t|
    t.string  "detail"
    t.integer "user_story_id"
    t.integer "version"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "time_zone"
    t.integer  "account_holder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_length"
    t.string   "subdomain"
    t.integer  "velocity"
  end

  create_table "beta_emails", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "burndowns", :force => true do |t|
    t.integer "sprint_id"
    t.integer "hours_left"
    t.date    "created_on"
    t.integer "story_points_complete"
    t.integer "story_points_remaining"
  end

  add_index "burndowns", ["sprint_id", "created_on"], :name => "index_burndowns_on_sprint_id_and_created_on"
  add_index "burndowns", ["sprint_id"], :name => "index_burndowns_on_sprint_id"

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.integer  "project_id"
    t.integer  "sent_count", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "invitations", ["email", "project_id"], :name => "index_invitations_on_email_and_project_id", :unique => true

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "account_id"
    t.integer  "authenticated",                        :default => 0
    t.string   "activation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_type"
    t.string   "hashed_password",        :limit => 40
    t.string   "salt",                   :limit => 40
    t.string   "api_key"
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
  end

  add_index "people", ["account_id", "api_key", "authenticated", "activation_code"], :name => "by_api_key"
  add_index "people", ["authentication_token"], :name => "index_people_on_authentication_token", :unique => true
  add_index "people", ["confirmation_token"], :name => "index_people_on_confirmation_token", :unique => true
  add_index "people", ["email"], :name => "index_people_on_email", :unique => true
  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "iteration_length"
    t.integer  "velocity"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "sprint_changes", :force => true do |t|
    t.integer  "auditable_id"
    t.integer  "sprint_id"
    t.integer  "person_id"
    t.text     "auditable_type"
    t.string   "kind"
    t.text     "changes_description"
    t.boolean  "major"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprint_elements", :force => true do |t|
    t.integer "sprint_id"
    t.integer "user_story_id"
    t.integer "position"
    t.integer "version"
  end

  add_index "sprint_elements", ["user_story_id", "sprint_id"], :name => "index_sprint_elements_on_user_story_id_and_sprint_id"

  create_table "sprints", :force => true do |t|
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :default => 0,  :null => false
    t.integer  "taggable_id",   :default => 0,  :null => false
    t.string   "taggable_type", :default => "", :null => false
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name",       :default => "", :null => false
    t.integer "account_id"
  end

  add_index "tags", ["name", "account_id"], :name => "index_tags_on_name_and_account_id", :unique => true

  create_table "task_developers", :force => true do |t|
    t.integer  "task_id"
    t.integer  "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string  "definition"
    t.text    "description"
    t.integer "hours",         :default => 1
    t.integer "position"
    t.integer "developer_id"
    t.integer "user_story_id"
    t.integer "version"
  end

  add_index "tasks", ["user_story_id"], :name => "index_tasks_on_user_story_id"

  create_table "team_members", :force => true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.boolean  "scrum_master", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "themes", :force => true do |t|
    t.string  "name",        :default => "", :null => false
    t.integer "account_id"
    t.text    "description"
    t.integer "position"
  end

  add_index "themes", ["name", "account_id"], :name => "index_themes_on_name_and_account_id", :unique => true

  create_table "themings", :force => true do |t|
    t.integer "theme_id",      :default => 0,  :null => false
    t.integer "themable_id",   :default => 0,  :null => false
    t.string  "themable_type", :default => "", :null => false
  end

  add_index "themings", ["theme_id", "themable_id", "themable_type"], :name => "index_themings_on_theme_id_and_themable_id_and_themable_type", :unique => true

  create_table "user_stories", :force => true do |t|
    t.text     "definition"
    t.text     "description"
    t.integer  "story_points"
    t.integer  "position"
    t.integer  "done",                :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_id"
    t.integer  "account_id"
    t.integer  "version"
    t.integer  "person_id"
    t.integer  "cannot_be_estimated", :default => 0
    t.string   "stakeholder",         :default => ""
    t.boolean  "delta",               :default => false
    t.integer  "project_id"
  end

end
