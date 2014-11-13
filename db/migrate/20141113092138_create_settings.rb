class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :notification_status

      t.timestamps
    end
  end
end
