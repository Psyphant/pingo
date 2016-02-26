class CreatePins < ActiveRecord::Migration[5.0]
  def change
    create_table :pins do |t|
      t.integer :parent_id
      t.integer :user_id
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :lft
      t.integer :rgt
      t.float :latitude
      t.float :longitude
      t.string :country
      t.string :city
      t.string :street
      t.boolean :gmaps
      t.integer :status
      t.integer :type
      t.string :picture

      t.timestamps
    end
  end
end
