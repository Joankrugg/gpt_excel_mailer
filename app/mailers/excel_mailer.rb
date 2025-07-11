class ExcelMailer < ApplicationMailer
  default from: ENV['MAIL_USERNAME']

  def send_excel
    attachments[params[:filename] || 'data.json'] = File.read(params[:file].path)

    mail(to: params[:to], subject: params[:subject]) do |format|
      format.text { render plain: params[:body] }
    end
  end
end
