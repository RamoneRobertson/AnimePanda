class CreateAnimes < ActiveRecord::Migration[7.1]
  def change
    create_table :animes do |t|
      t.string :title
      t.text :synopsis
      t.date :start_date
      t.date :end_date
      t.float :rating
      t.integer :rank
      t.integer :popularity
      t.string :picture_url
      t.integer :episode_count
      t.string :studio

      t.timestamps
    end
  end
end
