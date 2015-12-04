class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :name
      t.string :email
      t.text :suggestion
      t.timestamps null: false
    end
  end
end
