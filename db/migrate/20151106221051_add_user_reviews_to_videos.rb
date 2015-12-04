class AddUserReviewsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :user_reviews, :text
  end
end
