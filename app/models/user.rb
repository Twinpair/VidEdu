class User < ActiveRecord::Base

  has_many :subjects, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2,:facebook,:twitter]


  #Validations for the sign up page
  validates_presence_of :firstname, :on => :create, :message => "cant be blank"
  validates_presence_of :lastname, :on => :create, :message => "cant be blank"
  validates_presence_of :username, :on => :create, :message => "cant be blank"
  validates_uniqueness_of :username, :on => :create, :message => "is already taken."

  after_create :create_default_subject

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #       user.provider = auth.provider
  #       user.uid = auth.uid
  #       user.firstname = auth.info.name.split.first
  #       user.lastname = auth.info.name.split.last
  #       user.username = auth.info.nickname
  #       user.email = auth.info.email
  #   end
  # end
  
 def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(
          username: data["name"],
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20]
        )
      end
   end
end


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

  def create_default_subject
    @user = User.last
    @subject = Subject.new(subject: "Uncategorized", description: "Videos without a selected subject will go here", default_subject: true, user_id: @user.id)
    @subject.save
  end
end

  # class << self
  #   def from_omniauth(auth)
  #     user = User.find_or_initialize_by(uid: auth['uid'])
  #     user.name = auth['info']['name']
  #     user.token = auth['credentials']['token']
  #     user.save!
  #     user
  #   end
  # end
