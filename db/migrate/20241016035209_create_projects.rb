class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
