class InsertNotificationStatusToSettings < ActiveRecord::Migration
  def change
  	setting = Setting.new
  	setting.key = 'notification_status'
  	setting.value = 'true'
  	setting.save!
  end
end
