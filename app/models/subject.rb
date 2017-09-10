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
  before_save :normalize_subject_name

  def Subject.search(params)
    get_results(params[:search]).order_results(params[:sort])
  end

  def Subject.get_results(search_term)
    search_term.empty? ? Subject.where(private: false, default_subject: false) : Subject.where(private: false, default_subject: false).where("lower(subject) LIKE ?", "%#{search_term.downcase}%")
  end

  def Subject.order_results(sort_request)
    if sort_request.nil? || sort_request.empty? || sort_request == "Most Recently Updated"
      self.order(updated_at: :desc)
    elsif sort_request == "Least Recently Updated"
      self.order(updated_at: :asc)
    elsif sort_request == "Most Recently Created"
      self.order(created_at: :desc)
    elsif sort_request == "Least Recently Created"
      self.order(created_at: :asc)
    elsif sort_request == "Title: A-Z"
      self.order(subject: :asc) 
    elsif sort_request == "Title: Z-A"
      self.order(subject: :desc)
    end
  end

private
  
  def normalize_subject_name
    self.subject = subject.downcase.titleize
  end

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 2.megabytes
      errors.add(:picture, "should be less than 2MB")
    end
  end

end