# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_07_113544) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "community_place", null: false
    t.date "community_date", null: false
    t.date "community_limit", null: false
    t.integer "community_money", null: false
    t.string "community_all_tag"
    t.string "community_content"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "community_number_of_people"
    t.index ["user_id"], name: "index_communities_on_user_id"
  end

  create_table "community_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "community_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["community_id"], name: "index_community_users_on_community_id"
    t.index ["user_id"], name: "index_community_users_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "message_content", null: false
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "post_chess", null: false
    t.string "post_app", null: false
    t.string "post_time", null: false
    t.string "post_all_tag"
    t.string "post_content"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_name", null: false
    t.integer "user_id"
    t.integer "post_id"
    t.integer "private_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tournament_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_rooms_on_community_id"
    t.index ["post_id"], name: "index_rooms_on_post_id"
    t.index ["tournament_id"], name: "index_rooms_on_tournament_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "tournament_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_id"], name: "index_tournament_users_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_users_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "tournament_chess", null: false
    t.string "tournament_app", null: false
    t.string "tournament_time", null: false
    t.string "tournament_all_tag"
    t.string "tournament_content"
    t.integer "tournament_number_of_people"
    t.date "tournament_limit", null: false
    t.datetime "tournament_date", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_tournaments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "user_name", null: false
    t.string "user_chess", null: false
    t.string "user_app", null: false
    t.string "user_time", null: false
    t.string "user_content"
    t.string "user_image"
    t.integer "user_pref", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "communities", "users"
  add_foreign_key "community_users", "communities"
  add_foreign_key "community_users", "users"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "rooms", "communities"
  add_foreign_key "rooms", "posts"
  add_foreign_key "rooms", "tournaments"
  add_foreign_key "rooms", "users"
  add_foreign_key "tournament_users", "tournaments"
  add_foreign_key "tournament_users", "users"
  add_foreign_key "tournaments", "users"
end
