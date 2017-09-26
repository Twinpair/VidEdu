#  == Schema Information
#
#  Table name: videos
#
#  id                     , not null, primary key
#  t.string   "link"
#  t.string   "title"
#  t.string   "uid"
#  t.string   "subject"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#  t.text     "note"
#  t.integer  "subject_id"
#  t.integer  "user_id"
#  t.boolean  "private",    default: false

class Video < ActiveRecord::Base
  belongs_to :user
  has_one :user
  has_many :comments, dependent: :destroy
  belongs_to :subject
  validates :link, presence: true
  validates :subject_id, presence: { message: "Title: You already have a subject with that name" }

  self.per_page = 12

  def self.search(params)
    get_results(params[:search]).order_results(params[:sort])
  end

  def self.get_results(search_term)
    search_term.empty? ? Video.where(private: false) : Video.where(private: false).where("lower(title) LIKE ?", "%#{search_term.downcase}%")
  end

  def self.order_results(sort_request)
    if sort_request.nil? || sort_request.empty? || sort_request == "Most Recently Updated"
      self.order(updated_at: :desc)
    elsif sort_request == "Least Recently Updated"
      self.order(updated_at: :asc)
    elsif sort_request == "Most Recently Created"
      self.order(created_at: :desc)
    elsif sort_request == "Least Recently Created"
      self.order(created_at: :asc)
    elsif sort_request == "Title: A-Z"
      self.order(title: :asc) 
    elsif sort_request == "Title: Z-A"
      self.order(title: :desc)
    end
  end

end