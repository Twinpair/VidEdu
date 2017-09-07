class Subject < ActiveRecord::Base
# == Schema Information
#
# Table name: subjects
#
# id         :integer          not null, primary key
# t.string   "subject"
# t.text     "description"
# t.integer  "user_id"
# t.datetime "created_at",         null: false
# t.datetime "updated_at",         null: false

  has_many :videos
  belongs_to :user
  has_one :user
  validates :subject, presence: true, uniqueness: {scope: :user_id, message: "Title: You already have a subject with that name"}
  validates :user_id, presence: true
end