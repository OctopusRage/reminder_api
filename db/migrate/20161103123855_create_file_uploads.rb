class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|
      t.string :raw
      t.string :hash_id
      t.string :name
      t.string :ext
      t.integer :uploader_id
      t.string :uploader_type

      t.timestamps null: false
    end
  end
end
