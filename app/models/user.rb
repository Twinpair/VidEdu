class User < ActiveRecord::Base

  has_many :subjects
  has_many :videos
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  #Validations for the sign up page
  validates_presence_of :firstname, :on => :create, :message => "cant be blank"
  validates_presence_of :lastname, :on => :create, :message => "cant be blank"
  validates_presence_of :username, :on => :create, :message => "cant be blank"
  validates_uniqueness_of :username, :on => :create, :message => "is already taken."

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.firstname = auth.info.name.split.first
        user.lastname = auth.info.name.split.last
        user.username = auth.info.nickname
        user.email = auth.info.email
    end
  end
 

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
        new(session["devise.user_attributes"], without_protection: true) do |user|
            user.attributes = params
            user.valid?
        end
    else
        super
    end
  end

  def password_required?
    super && provider.blank?
  end
end
