class Notification < ActiveRecord::Base
  after_commit :push_notification!, on: :create

  private
  def push_notification!
    begin
      Pusher.trigger('veritrans_notification', 'on_notify', pusher_message)
    rescue Exception => e
      Rails.logger.debug "Push notification error"
      Rails.logger.debug e.message
    end
  end

  def pusher_message
    json = as_json
    message_obj =  JSON.parse( json['message'] ) if json['message']
    json['message'] = message_obj
    json
  end
end
