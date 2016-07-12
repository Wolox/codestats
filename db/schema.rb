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

ActiveRecord::Schema.define(version: 20160712182743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.boolean  "default",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "github_sha"
    t.string   "slug"
  end

  add_index "branches", ["project_id", "name"], name: "index_branches_on_project_id_and_name", unique: true, using: :btree
  add_index "branches", ["project_id", "slug"], name: "index_branches_on_project_id_and_slug", unique: true, using: :btree
  add_index "branches", ["project_id"], name: "index_branches_on_project_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.integer  "branch_id"
    t.string   "name"
    t.string   "value"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "minimum"
  end

  add_index "metrics", ["branch_id"], name: "index_metrics_on_branch_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "github_name"
    t.string   "github_url"
    t.string   "github_avatar_url"
    t.string   "slug"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "github_repo"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "metrics_token"
    t.string   "slug"
  end

  add_index "projects", ["organization_id", "slug"], name: "index_projects_on_organization_id_and_slug", unique: true, using: :btree
  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree

  create_table "projects_teams", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "project_id"
  end

  add_index "projects_teams", ["project_id"], name: "index_projects_teams_on_project_id", using: :btree
  add_index "projects_teams", ["team_id"], name: "index_projects_teams_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "teams", ["organization_id"], name: "index_teams_on_organization_id", using: :btree

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  add_index "teams_users", ["team_id"], name: "index_teams_users_on_team_id", using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "github_nickname"
    t.string   "github_avatar_url"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "branches", "projects"
  add_foreign_key "metrics", "branches"
  add_foreign_key "projects", "organizations"
  add_foreign_key "teams", "organizations"
end
