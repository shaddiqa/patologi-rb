Rails.application.routes.draw do

  root 'notifications#welcome'

  get 'ping' => proc { [200, {"Content-Type" => "text/plain"}, ["Pong!" ]] }

  post 'notifications/create' => 'notifications#create'
  post 'notifications/create_error' => 'notifications#create_error'

  get 'notifications' => 'notifications#index'

  post 'notifications' => 'notifications#notify'

  get 'notifications/clear' => 'notifications#clear'

  put 'notifications/toggle' => 'notifications#toggle'
  put 'notifications/status/:status' => 'notifications#set_status'
  get 'notifications/status' => 'notifications#show_notification_status_setting'

  post 'notifications/panda' => 'notifications#panda'
end
