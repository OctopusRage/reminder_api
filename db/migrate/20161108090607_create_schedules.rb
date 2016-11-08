class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :title
      t.date :started_at
      t.date :ended_at
      t.text :description
      t.string :location
      t.references :user, index: true, foreign_key: true
      t.boolean :status

      t.timestamps null: false
    end
  end
end
