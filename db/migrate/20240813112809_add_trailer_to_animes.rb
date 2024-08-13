class AddTrailerToAnimes < ActiveRecord::Migration[7.1]
  def change
    add_column :animes, :trailer, :string
  end
end
