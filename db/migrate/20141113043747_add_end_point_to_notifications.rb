class AddEndPointToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :flag, :boolean
  end
end
