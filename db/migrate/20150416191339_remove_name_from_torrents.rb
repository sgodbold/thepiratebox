class RemoveNameFromTorrents < ActiveRecord::Migration
  def change
    remove_column :torrents, :name
  end
end
