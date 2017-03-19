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

ActiveRecord::Schema.define(version: 20170319022810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "songkick_id"
    t.string "spotify_id"
  end

  create_table "concert_artists", force: :cascade do |t|
    t.integer "concert_id"
    t.integer "artist_id"
    t.index ["artist_id"], name: "index_concert_artists_on_artist_id", using: :btree
    t.index ["concert_id"], name: "index_concert_artists_on_concert_id", using: :btree
  end

  create_table "concert_attendees", force: :cascade do |t|
    t.integer  "concert_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "number"
    t.string   "status"
    t.index ["concert_id"], name: "index_concert_attendees_on_concert_id", using: :btree
    t.index ["user_id"], name: "index_concert_attendees_on_user_id", using: :btree
  end

  create_table "concerts", force: :cascade do |t|
    t.integer  "venue_id"
    t.string   "songkick_id"
    t.datetime "at"
    t.index ["venue_id"], name: "index_concerts_on_venue_id", using: :btree
  end

  create_table "email_addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_email_addresses_on_email", using: :btree
    t.index ["user_id"], name: "index_email_addresses_on_user_id", using: :btree
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "approved_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["from_id"], name: "index_friendships_on_from_id", using: :btree
    t.index ["to_id"], name: "index_friendships_on_to_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json     "store"
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "mails", force: :cascade do |t|
    t.integer  "concert_id"
    t.integer  "email_address_id"
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "html"
    t.text     "text"
    t.text     "headers"
    t.datetime "created_at",       null: false
    t.index ["concert_id"], name: "index_mails_on_concert_id", using: :btree
    t.index ["email_address_id"], name: "index_mails_on_email_address_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.json     "meta"
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  create_table "venues", force: :cascade do |t|
    t.string "songkick_id"
    t.string "name"
    t.string "address"
  end

  add_foreign_key "concert_artists", "artists"
  add_foreign_key "concert_artists", "concerts"
  add_foreign_key "concert_attendees", "concerts"
  add_foreign_key "concert_attendees", "users"
  add_foreign_key "concerts", "venues"
  add_foreign_key "email_addresses", "users"
  add_foreign_key "mails", "concerts"
  add_foreign_key "mails", "email_addresses"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
