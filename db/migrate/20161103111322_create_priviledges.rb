class CreatePriviledges < ActiveRecord::Migration
  def change
    create_table :priviledges do |t|
      t.string :access
      t.boolean :status

      t.timestamps null: false
    end
  end
end
