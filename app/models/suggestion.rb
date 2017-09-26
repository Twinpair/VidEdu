class Suggestion < ActiveRecord::Base
  validates_presence_of :name, :message => "cant be blank"
  validates_presence_of :email,  :message => "cant be blank"
  validates_presence_of :suggestion,  :message => "cant be blank"
end