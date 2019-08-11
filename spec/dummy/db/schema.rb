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

ActiveRecord::Schema.define(version: 2019_08_11_172837) do

  create_table "roles", force: :cascade do |t|
    t.integer "user_id"
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "important", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "roles_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tasks_count", default: 0, null: false
    t.integer "important_tasks_count", default: 0, null: false
    t.integer "unimportant_tasks_count", default: 0, null: false
  end

end
