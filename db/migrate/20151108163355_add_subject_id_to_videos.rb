class AddSubjectIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :subject_id, :integer
  end
end
