class AddDescriptionToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :description, :text
  end
end
