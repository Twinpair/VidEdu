class AddSubjectReferenceToVideos < ActiveRecord::Migration
  def change
    add_reference :videos, :subject, index: true, foreign_key: true
  end
end
