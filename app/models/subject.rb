class Subject < ActiveRecord::Base
    # attr_accessible :subject, :description

    has_many :videos
    belongs_to :user
    has_one :user
    searchkick

    has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", small: "200x200>", thumb: "100x100#" } , default_url: "/images/:style/missing.png"
   # validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


end