class AddDefaultValueToWatchStatusInBookmarks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bookmarks, :watch_status, 0
  end
end
