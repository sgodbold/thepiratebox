class AddFilenameToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :filename, :string
  end
end
