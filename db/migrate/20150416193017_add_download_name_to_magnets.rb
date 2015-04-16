class AddDownloadNameToMagnets < ActiveRecord::Migration
  def change
    add_column :magnets, :download_name, :string
  end
end
