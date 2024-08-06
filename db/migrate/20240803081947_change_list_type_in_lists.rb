class ChangeListTypeInLists < ActiveRecord::Migration[7.1]
  def change
    change_column :lists, :list_type, :integer, using: 'list_type::integer'
  end
end
