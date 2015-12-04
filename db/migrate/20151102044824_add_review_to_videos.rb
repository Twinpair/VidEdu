class AddReviewToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :review, :text
  end
end
