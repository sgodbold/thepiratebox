class CreateMagnets < ActiveRecord::Migration
  def change
    create_table :magnets do |t|
      t.text :url
      t.float :upload
      t.float :download

      t.timestamps
    end
  end
end
