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

ActiveRecord::Schema.define(:version => 20140821184626) do

  create_table "release_notes", :force => true do |t|
    t.integer  "release_id"
    t.text     "release_notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "releases", :force => true do |t|
    t.string   "accounts"
    t.string   "accounts_extra"
    t.string   "addons"
    t.string   "collaborate"
    t.string   "help"
    t.string   "mysageone"
    t.string   "payroll"
    t.date     "date"
    t.text     "notes",               :limit => 255
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "status",                             :default => "UAT"
    t.string   "coordinator"
    t.string   "accountant_edition"
    t.string   "accounts_production"
  end

end
