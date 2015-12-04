class AddNoteToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :note, :text
  end
end
