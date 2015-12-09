class RemoveSlugFromVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :slug, :string
  end
end
