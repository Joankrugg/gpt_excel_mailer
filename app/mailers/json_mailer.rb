class JsonMailer < ApplicationMailer
  def send_json
    attachments['data.json'] = {
      mime_type: 'application/json',
      content: params[:json_data].to_json
    }

    mail(to: params[:to], subject: 'Voici le fichier JSON')
  end
end