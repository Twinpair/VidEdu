class RemoveUserIdFromSubjects < ActiveRecord::Migration
  def change
    remove_column :subjects, :user_id, :integer
  end
end
