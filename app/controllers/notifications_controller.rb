class NotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	respond_to :json

	def index
		@count = Notification.all.count
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
		@notifications = Notification.where(order_id: params[:order_id], flag: params[:flag].to_b)
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
				@notification.message = params.to_json
				@notification.flag = flag
				@notification.save
			rescue Exception => e
				render_message(500, "Error while trying to create new TrueFalseQuestion.", e.message)
			end
	  	end

end
