class NotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	respond_to :json

	def index
		@count = Notification.all.count
	end

	def create
		begin
			params.delete('action')
			params.delete('controller')
			params.delete('notification')
			@notification = Notification.new
			@notification.order_id = params[:order_id]
			@notification.message = params.to_json
			@notification.save
		rescue Exception => e
			render_message(500, "Error while trying to create new TrueFalseQuestion.", e.message)
		end
	end

	def clear
		Notification.destroy_all
	end

	def all
		@notifications = Notification.all.order(created_at: :desc)
	end

	def show
		@notifications = Notification.where(order_id: params[:order_id])
	end

	private
		def render_message(status_code, message, exception=nil)
	  	@result = { status_code: status_code,
	  									message: message,
	  								exception: exception }
	  	render status: status_code
	  end
end
