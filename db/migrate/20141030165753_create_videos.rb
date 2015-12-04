class CreateVideos < ActiveRecord::Migration
   
   
  def change
    create_table :videos do |t|
      t.string :link
      t.string :title
      t.datetime :published_at
      t.integer :likes
      t.integer :dislikes
      t.string :uid


      t.string :name
      t.text :video_description
      t.string :subject
      t.integer :rating
      t.text :comment


      t.timestamps
    end
    add_index :videos, :uid
  end
end
