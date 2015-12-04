class AddChannelTitleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :channel_title, :string
  end
end
