# app/controllers/api/v1/json_mailer_controller.rb
class Api::V1::JsonMailerController < ApplicationController
  before_action :authenticate_api_key, except: [:openapi]

  def send_json
    to = params[:to]
    json_data = params[:json_data]

    JsonMailer.with(to: to, json_data: json_data).send_json.deliver_now
    render json: { status: 'ok', message: "JSON envoyé à #{to}" }
  end

  def openapi
    render json: {
      openapi: "3.0.0",
      info: {
        title: "Mailer API",
        version: "1.0.0",
        description: "Permet à un agent GPT d'envoyer un JSON par mail."
      },
      servers: [
        { url: "https://mailer-api.onrender.com/api/v1/openapi" }
      ],
      paths: {
        "/api/v1/send_json": {
          post: {
            operationId: "sendJsonByEmail",
            summary: "Envoie un JSON par e-mail",
            parameters: [],
            requestBody: {
              required: true,
              content: {
                "application/json": {
                  schema: {
                    type: "object",
                    properties: {
                      to: { type: "string", description: "Adresse email du destinataire" },
                      json_data: { type: "object", description: "Contenu JSON à envoyer" }
                    },
                    required: ["to", "json_data"]
                  }
                }
              }
            },
            responses: {
              "200": { description: "Email envoyé" },
              "401": { description: "Clé API invalide" }
            }
          }
        }
      }
    }
  end


  private

  def authenticate_api_key
    unless request.headers["X-Api-Key"] == ENV["GPT_API_KEY"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end