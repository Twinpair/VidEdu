class AddNoteSummaryToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :note_summary, :text
  end
end
