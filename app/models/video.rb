# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  link         :string(255)
#  title        :string(255)
#  published_at :datetime
#  duration     :string(255)
#  likes        :integer
#  dislikes     :integer
#  uid          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  subject_id   :integer
#  yt_description :text

class Video < ActiveRecord::Base
  belongs_to :user
  has_one :user
  has_many :comments
  belongs_to :subject
  has_many :ratings

  def Video.search(keyword)
    videos = Video.all
    videos = videos.where("lower(title) LIKE ?", "%#{keyword.downcase}%")
  end

end