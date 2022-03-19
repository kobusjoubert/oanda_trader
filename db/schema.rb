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

ActiveRecord::Schema.define(version: 20190114055744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "trade_account_id", null: false
    t.string "alias"
    t.string "balance"
    t.string "encrypted_access_token"
    t.string "encrypted_access_token_iv"
    t.boolean "practice", default: false
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_concurrent_trades", default: 1, null: false
    t.text "summary"
    t.index ["trade_account_id"], name: "index_accounts_on_trade_account_id", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.integer "level", default: 0
    t.integer "user_strategy_id"
    t.integer "position"
    t.integer "action"
    t.integer "units"
    t.decimal "price", precision: 11, scale: 5
    t.integer "transaction_id"
    t.decimal "profit_loss", precision: 14, scale: 4
    t.decimal "take_profit", precision: 11, scale: 5
    t.decimal "stop_loss", precision: 11, scale: 5
    t.index ["action", "position"], name: "index_activities_on_action_and_position"
    t.index ["position"], name: "index_activities_on_position"
    t.index ["user_strategy_id"], name: "index_activities_on_user_strategy_id"
  end

  create_table "instruments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "ticker"
    t.string "description"
    t.string "type"
    t.string "session"
    t.string "exchange"
    t.string "listed_exchange"
    t.float "min_movement"
    t.float "min_movement_2"
    t.integer "price_scale"
    t.boolean "fractional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strategies", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "worker_name", null: false
    t.text "description"
    t.time "market_open_at"
    t.time "market_close_at"
    t.text "default_config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instrument"
    t.time "trade_from"
    t.time "trade_to"
    t.time "exit_friday_at"
    t.index ["worker_name"], name: "index_strategies_on_worker_name", unique: true
  end

  create_table "user_strategies", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.integer "strategy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "margin"
    t.integer "take_profit_at"
    t.integer "stop_loss_at"
    t.time "cut_off_time"
    t.integer "chart_interval"
    t.integer "units"
    t.boolean "favourite", default: false
    t.integer "state", default: 0
    t.integer "consecutive_losses_allowed"
    t.index ["account_id"], name: "index_user_strategies_on_account_id"
    t.index ["favourite"], name: "index_user_strategies_on_favourite"
    t.index ["strategy_id"], name: "index_user_strategies_on_strategy_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name", default: "", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "activities", "user_strategies", on_delete: :cascade
  add_foreign_key "user_strategies", "accounts"
  add_foreign_key "user_strategies", "strategies"
end
