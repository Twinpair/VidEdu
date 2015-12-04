class AddVideoIdToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :video_id, :integer
  end
end
