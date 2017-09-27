class UpdateSubjectForeignKeyOnVideos < ActiveRecord::Migration
  def change
    # remove the old foreign_key
    remove_foreign_key :videos, :subjects

    # add the new foreign_key
    add_foreign_key :videos, :subjects, on_delete: :nullify
  end
end
