class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates :body, presence: true, length: {maximum: 2000}
  validates :user_id, presence: true
  validates :video_id, presence: true
end
