class AddPrivateIndexToSubjects < ActiveRecord::Migration
  def change
    add_index :subjects, :private
  end
end
