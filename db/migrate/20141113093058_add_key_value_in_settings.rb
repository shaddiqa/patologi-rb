class AddKeyValueInSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :key, :string
  	add_column :settings, :value, :string
  	remove_column :settings, :notification_status
  end
end
