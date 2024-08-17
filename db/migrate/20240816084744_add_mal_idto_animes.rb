class AddMalIdtoAnimes < ActiveRecord::Migration[7.1]
  def change
    add_column :animes, :mal_id, :integer
  end
end
