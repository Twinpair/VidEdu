class Comment < ActiveRecord::Base
#  == Schema Information ==
#
#  Table name: comments
#
#  id                     , not null, primary key
#  t.text     "body"
#  t.integer  "user_id"
#  t.datetime "created_at", null: false
#  t.datetime "updated_at", null: false
#  t.integer  "video_id"
  
  belongs_to :user
  belongs_to :video
  validates :body, presence: true, length: {maximum: 2000}
  validates :user_id, presence: true
  validates :video_id, presence: true
end
