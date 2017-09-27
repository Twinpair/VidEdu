class AddPrivateIndexToVideos < ActiveRecord::Migration
  def change
    add_index :videos, :private
  end
end
