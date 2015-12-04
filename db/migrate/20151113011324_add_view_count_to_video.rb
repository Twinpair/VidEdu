class AddViewCountToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :view_count, :integer
  end
end
