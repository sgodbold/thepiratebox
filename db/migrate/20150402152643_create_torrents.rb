class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.text :url
      t.float :upload
      t.float :download

      t.timestamps
    end
  end
end
