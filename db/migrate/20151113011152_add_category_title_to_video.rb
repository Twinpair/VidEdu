class AddCategoryTitleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :category_title, :string
  end
end
