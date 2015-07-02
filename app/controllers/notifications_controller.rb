class NotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	respond_to :json

	def index
		@count = Notification.all.count
	end

  def notify
    @notification_status = Setting.find_by_key('notification_status')
    push_notification!

    if(@notification_status.value.to_b)
      save!
      render text: '{"status": "OK"}', status: 200, layout: false
    else
      render text: '{"status": "Not OK"}', status: 500, layout: false
    end
  end

  def panda
    if params[:paymentInfo].nil? || params[:signature].nil?
      render text: '{"status": "Error", "message" : "Incomplete POST parameter. paymentResult and signature must exist"}', status: 400, layout: false
    else
      params[:payment_info] = JSON.parse(Base64.urlsafe_decode64(params[:paymentInfo]))
      params[:order_id] = params[:payment_info]["paymentId"]
      params[:status_code] = params[:payment_info]["resultType"]

      save!
      render text: '{"status": "OK"}', status: 200, layout: false
    end
  end

  def set_status
    @notification_status = Setting.find_by_key('notification_status')
    @notification_status.value = params[:status].to_b
    @notification_status.save!
    response_body = {
      "status" => @notification_status.value.to_b
    }
    render text: response_body.to_json, status: 200, layout: false
  end

  def toggle
    @notification_status = Setting.find_by_key('notification_status')
    @notification_status.value = (!@notification_status.value.to_b).to_s
    @notification_status.save!
    response_body = {
      "status" => @notification_status.value.to_b
    }
    render text: response_body.to_json, status: 200, layout: false
  end

  def show_notification_status_setting
    @notification_status = Setting.find_by_key('notification_status')
    response_body = {
      "status" => @notification_status.value.to_b
    }
    render text: response_body.to_json, status: 200, layout: false
  end

	def create
		save!(true)
	end

	def create_error
		save!(false)
		render status: 500
	end

	def clear
		Notification.destroy_all
	end

	def all
		@notifications = Notification.all.order(created_at: :desc)
	end

	def show
		# @notifications = Notification.where(order_id: params[:order_id], flag: params[:flag].to_b)
		@notifications = Notification.order('created_at desc')
    
    @notifications.where!('created_at > ?', search_params[:created_after])  if search_params[:created_after].present?
	  @notifications.where!('created_at < ?', search_params[:created_before]) if search_params[:created_before].present?
	  @notifications.where!(order_id: search_params[:order_id]) if search_params[:order_id].present?
	  @notifications.where!(flag: search_params[:flag].to_b) if search_params[:flag].present?
	  @notifications.where!(status_code: search_params[:status_code]) if search_params[:status_code].present?

	end

	private
		def render_message(status_code, message, exception=nil)
		@result = { status_code: status_code,
									message: message,
									exception: exception }
		render status: status_code
	end

	def save!(flag=true)
		begin
  		params.delete('action')
  		params.delete('controller')
  		params.delete('notification')
  		@notification = Notification.new
  		@notification.order_id = params[:order_id]
  		@notification.status_code = params[:status_code]
  		@notification.message = params.to_json
  		@notification.flag = flag
  		@notification.save
  	rescue Exception => e
  		render_message(500, "Error while trying to create new TrueFalseQuestion.", e.message)
  	end
	end

	def search_params
		params.permit(:flag, :order_id, :status_code)
	end

  def push_notification!
    begin
      Pusher.trigger('veritrans_notification', 'on_notify', params)
    rescue Exception => e
      Rails.logger.debug "Push notification error"
      Rails.logger.debug e.message
    end
  end

end
