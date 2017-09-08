class AddPrivateToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :private, :boolean, :default => false
  end
end
