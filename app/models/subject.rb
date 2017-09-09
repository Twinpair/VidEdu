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
  mount_uploader :picture, PictureUploader
  validates :subject, presence: true, uniqueness: {scope: :user_id, message: "Title: You already have a subject with that name"}
  validates :user_id, presence: true
  validate  :picture_size

private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 2.megabytes
      errors.add(:picture, "should be less than 2MB")
    end
  end

end