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

    
    # attr_accessible :id, :title, :uid

    belongs_to :user
    has_one :user
    has_many :comments

    belongs_to :subject
    has_many :ratings

    searchkick text_start: [:title,:reivew,:rating,"Subject.subject"]


  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
  validates :link, presence: true, format: YT_LINK_FORMAT


 

 
end

