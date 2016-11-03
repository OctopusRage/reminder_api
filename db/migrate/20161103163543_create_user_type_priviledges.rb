class CreateUserTypePriviledges < ActiveRecord::Migration
  def change
    create_table :user_type_priviledges do |t|
      t.references :priviledge, index: true, foreign_key: true
      t.references :user_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
