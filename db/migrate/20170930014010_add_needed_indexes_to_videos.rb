class AddNeededIndexesToVideos < ActiveRecord::Migration
  def change
    add_index :videos, :title
    add_index :videos, :note
    add_index :videos, :created_at
    add_index :videos, :updated_at
  end
end
