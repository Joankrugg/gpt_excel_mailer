class Api::V1::JsonMailerController < ApplicationController
  before_action :authenticate_api_key

  def send_json
    to = params[:to]
    json_data = params[:json_data]

    JsonMailer.with(to: to, json_data: json_data).send_json.deliver_now
    render json: { status: 'ok', message: "JSON envoyé à #{to}" }
  end

  private

  def authenticate_api_key
    unless request.headers["X-Api-Key"] == ENV["GPT_API_KEY"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end