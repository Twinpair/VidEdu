class AddDefaultSubjectIndexToSubjects < ActiveRecord::Migration
  def change
    add_index :subjects, :default_subject
  end
end
