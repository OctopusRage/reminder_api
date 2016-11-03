class AddUrlToFileUpload < ActiveRecord::Migration
  def change
    add_column :file_uploads, :url, :string
  end
end
