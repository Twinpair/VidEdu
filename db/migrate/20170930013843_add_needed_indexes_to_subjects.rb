class AddNeededIndexesToSubjects < ActiveRecord::Migration
  def change
    add_index :subjects, :description
    add_index :subjects, :created_at
    add_index :subjects, :updated_at
  end
end
