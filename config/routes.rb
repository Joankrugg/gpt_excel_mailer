Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'send_excel', to: 'excel_mailer#send_excel'
    end
  end
end
