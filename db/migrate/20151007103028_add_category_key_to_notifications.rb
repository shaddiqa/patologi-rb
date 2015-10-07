class AddCategoryKeyToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :category_key, :string
  end
end
