Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'send_json', to: 'json_mailer#send_json'
      get 'openapi', to: 'json_mailer#openapi'
    end
  end
end
