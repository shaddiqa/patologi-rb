if @result.blank?
	json.data do
		json.result true
		json.id @notification.id
	end
else
	json.set! :status_code, @result[:status_code]
	json.set! :message, @result[:message]
	json.set! :exception, @result[:exception] unless @result[:exception].blank?
end