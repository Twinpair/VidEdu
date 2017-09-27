class RemoveUserIdVideoIdFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :user_id, :integer
    remove_column :comments, :video_id, :integer
  end
end
