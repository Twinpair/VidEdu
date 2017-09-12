class Suggestion < ActiveRecord::Base
#  == Schema Information ==
#
#  Table name: suggestions
#
#  id                     , not null, primary key
#  t.string   "name"
#  t.string   "email"
#  t.text     "suggestion"
#  t.datetime "created_at", null: false
#  t.datetime "updated_at", null: false

  validates_presence_of :name, :message => "cant be blank"
  validates_presence_of :email,  :message => "cant be blank"
  validates_presence_of :suggestion,  :message => "cant be blank"
end