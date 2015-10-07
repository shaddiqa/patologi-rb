class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def welcome
    @count = Notification.all.count
  end

  def notify
    @notification_status = Setting.find_by_key('notification_status')

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

  #def all
  #  @notifications = Notification.all.order(created_at: :desc)
  #end

  def index
    # @notifications = Notification.where(order_id: params[:order_id], flag: params[:flag].to_b)
    @notifications = Notification.order('created_at desc')

    if search_params[:created_after].present?
      @notifications.where!('created_at > ?', search_params[:created_after])
    end
    if search_params[:created_before].present?
      @notifications.where!('created_at < ?', search_params[:created_before])
    end
    if search_params[:order_id].present?
      @notifications.where!(order_id: search_params[:order_id])
    end
    if search_params[:flag].present?
      @notifications.where!(flag: search_params[:flag].to_b)
    end
    if search_params[:status_code].present?
      @notifications.where!(status_code: search_params[:status_code])
    end
    if search_params[:category_key].present?
      @notifications.where!(category_key: search_params[:category_key])
    end
  end

  private
    def render_message(status_code, message, exception = nil)
    @result = { status_code: status_code,
                message: message,
                exception: exception }
    render status: status_code
  end

  def save!(flag = true)
    begin
      #params.delete('action')
      #params.delete('controller')
      #params.delete('notification')
      #post_params = ActiveSupport::JSON.decode(request.body.read).symbolize_keys
      @notification = Notification.new
      @notification.order_id = params[:order_id]
      @notification.status_code = params[:status_code]
      @notification.message = request.body.read
      if params[:key].present?
        @notification.category_key = params[:key]
      end
      @notification.flag = flag
      @notification.save
    rescue Exception => e
      render_message(500, "Error while trying to create new TrueFalseQuestion.", e.message)
    end
  end

  def search_params
    params.permit(:flag, :order_id, :status_code, :category_key)
  end

end
