class RemoveUserIdAndSubjectIdFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :user_id, :integer
    remove_column :videos, :subject_id, :integer
  end
end
