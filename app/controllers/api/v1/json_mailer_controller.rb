# app/controllers/api/v1/json_mailer_controller.rb
class Api::V1::JsonMailerController < ApplicationController
  before_action :authenticate_api_key, except: [:openapi]

  def openapi
    render json: {
      openapi: "3.1.0",
      info: {
        title: "Mailer API",
        version: "1.0.0",
        description: "Permet à un agent GPT d'envoyer un JSON par mail.",
        termsOfService: "https://millesime-collection.com/politique-confidentialite/",
        contact: {
          name: "Millésime",
          email: "p.chambon@millesime.life"
        },
        license: {
          name: "MIT"
        }
      },
      servers: [
        {
          url: "https://mailer-api-o3zn.onrender.com"
        }
      ],
      "x-policy": {
        url: "https://millesime-collection.com/politique-confidentialite/"
      },
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