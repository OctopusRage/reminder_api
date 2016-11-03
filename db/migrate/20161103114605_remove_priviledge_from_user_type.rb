class RemovePriviledgeFromUserType < ActiveRecord::Migration
  def change
    remove_column :user_types, :priviledge_id, :integer
  end
end
