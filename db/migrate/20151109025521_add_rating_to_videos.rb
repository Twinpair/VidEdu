class AddRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :rating, :integer
  end
end
