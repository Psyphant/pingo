class CreatePinsFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :pins_files do |t|
      t.references :user, foreign_key: true
      t.references :pin, foreign_key: true
      t.string :file
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
