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
			@notification.message = params.to_s
			@notification.save
		rescue Exception => e
			render_message(500, "Error while trying to create new TrueFalseQuestion.", e.message)
		end
	end

	def clear
		Notification.destroy_all
	end

	def all
		@notifications = Notification.all
	end

	private
		def render_message(status_code, message, exception=nil)
	  	@result = { status_code: status_code,
	  									message: message,
	  								exception: exception }
	  	render status: status_code
	  end
end
