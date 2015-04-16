class AddAttachmentToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :attachment, :string
    add_column :torrents, :name, :string
    remove_column :torrents, :url, :string
  end
end
