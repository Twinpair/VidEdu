class RemoveColumnsFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :likes, :integer
    remove_column :videos, :dislikes, :integer
    remove_column :videos, :published_at, :datetime
    remove_column :videos, :name, :string
    remove_column :videos, :video_description, :text
    remove_column :videos, :rating, :integer
    remove_column :videos, :comment, :text
    remove_column :videos, :note_summary, :text
    remove_column :videos, :review, :text
    remove_column :videos, :time, :float
    remove_column :videos, :user_reviews, :text
    remove_column :videos, :yt_description, :text
    remove_column :videos, :category_title, :string
    remove_column :videos, :channel_title, :string
    remove_column :videos, :view_count, :integer
    remove_column :videos, :is_public, :boolean
  end
end
