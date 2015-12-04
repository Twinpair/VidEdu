class AddYtDescriptionToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :yt_description, :text
  end
end
