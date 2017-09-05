class RemoveColumnsFromSubjects < ActiveRecord::Migration
  def change
    remove_column :subjects, :image_file_name, :string
    remove_column :subjects, :image_content_type, :string
    remove_column :subjects, :image_file_size, :integer
    remove_column :subjects, :image_updated_at, :datetime
    remove_column :subjects, :video_id, :integer
  end
end
