require 'tempfile'
require 'json'

class Api::V1::ExcelMailerController < ApplicationController
  before_action :authenticate_api_key

  def send_excel
    to = params[:to]
    subject = params[:subject]
    body = params[:body]
    json_data = params[:excel_data].to_json

    file = Tempfile.new(['data', '.json'])
    File.write(file.path, json_data)

    ExcelMailer.with(to: to, subject: subject, body: body, file: file, filename: "tableau.json").send_excel.deliver_now

    file.close
    file.unlink

    render json: { status: "ok", message: "JSON envoyé à #{to}" }
  rescue => e
    render json: { status: "error", message: e.message }, status: 500
  end
  def authenticate_api_key
    unless request.headers["X-Api-Key"] == ENV["GPT_API_KEY"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
