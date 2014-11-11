class AddOrderIdToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :order_id, :string
  end
end
