# app/controllers/api/v1/json_mailer_controller.rb
class Api::V1::JsonMailerController < ApplicationController
  before_action :authenticate_api_key, except: [:openapi]

  def openapi
    render json: {
      openapi: "3.0.0",
      info: {
        title: "Mailer API - Millesime",
        version: "1.0.0",
        description: "Envoie une pièce jointe JSON par email depuis un agent GPT."
      },
      servers: [
        {
          url: "https://mailer-api-o3zn.onrender.com" # Ton URL Render à jour
        }
      ],
      paths: {
        "/api/v1/send_json": {
          post: {
            operationId: "sendJsonByEmail",
            summary: "Envoie un JSON en pièce jointe par mail",
            parameters: [],
            requestBody: {
              required: true,
              content: {
                "application/json": {
                  schema: {
                    type: "object",
                    properties: {
                      to: {
                        type: "string",
                        description: "Adresse email du destinataire (ex. millesimelife@gmail.com)",
                        example: "millesimelife@gmail.com"
                      },
                      json_data: {
                        type: "object",
                        description: "Contenu du JSON à envoyer",
                        example: {
                          nom: "Philippe",
                          projet: "GPT Mailer"
                        }
                      }
                    },
                    required: ["to", "json_data"]
                  }
                }
              }
            },
            responses: {
              "200": {
                description: "L'email a bien été envoyé avec le JSON en pièce jointe."
              },
              "401": {
                description: "Clé API invalide."
              }
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