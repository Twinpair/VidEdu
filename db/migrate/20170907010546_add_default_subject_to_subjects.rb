class AddDefaultSubjectToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :default_subject, :boolean, :default => false
  end
end
