class AddVideoTimestampToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :time, :float
  end
end
