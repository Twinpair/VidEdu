class Comment < ActiveRecord::Base
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  user_id    :integer
#  video_id    :integer
#  created_at :datetime
#  updated_at :datetime
  
  belongs_to :user
  belongs_to :video
  validates :body, presence: true, length: {maximum: 2000}
  validates :user_id, presence: true
  validates :video_id, presence: true
end
