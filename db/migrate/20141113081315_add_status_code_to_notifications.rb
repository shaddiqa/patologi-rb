class AddStatusCodeToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :status_code, :string
  end
end
