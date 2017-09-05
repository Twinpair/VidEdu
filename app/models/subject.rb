class Subject < ActiveRecord::Base
# == Schema Information
#
# Table name: subjects
#
# id         :integer          not null, primary key
# t.string   "subject"
# t.datetime "created_at",         null: false
# t.datetime "updated_at",         null: false
# t.text     "description"
# t.integer  "user_id"

  has_many :videos
  belongs_to :user
  has_one :user
end