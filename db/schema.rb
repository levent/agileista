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

ActiveRecord::Schema.define(:version => 20101008225925) do

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

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "account_id"
    t.integer  "authenticated",                 :default => 0
    t.string   "activation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_type"
    t.string   "hashed_password", :limit => 40
    t.string   "salt",            :limit => 40
    t.string   "api_key"
  end

  add_index "people", ["account_id", "api_key", "authenticated", "activation_code"], :name => "by_api_key"

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
    t.integer "hours"
    t.integer "position"
    t.integer "developer_id"
    t.integer "user_story_id"
    t.integer "version"
  end

  add_index "tasks", ["user_story_id"], :name => "index_tasks_on_user_story_id"

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
  end

end
