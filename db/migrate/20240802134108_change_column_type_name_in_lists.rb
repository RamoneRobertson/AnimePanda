class ChangeColumnTypeNameInLists < ActiveRecord::Migration[7.1]
  def change
    rename_column :lists, :type, :list_type
  end
end
