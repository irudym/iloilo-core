module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  # define custom error subclasses - rescue catches 'StandardErrors'
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class CannotUpdate < StandardError; end

  included do
    # define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::CannotUpdate, with: :four_twenty_two
    # rescue_from NoMethodError, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      errors = [{ status: 404, title: 'Record Not Found', detail: e.message }]
      # json_response( {message: e.message}, :not_found)
      json_response( { errors: errors }, :not_found)
    end

    rescue_from ActionController::ParameterMissing do |e| 
      errors = [{ status: 422, title: 'Parameter Missing', detail: e.message }]
      json_response( { errors: errors}, :unprocessable_entity)
    end

    private

    # JSON response with message, status code 422 - uprocessable entity
    def four_twenty_two(e)
      errors = [{ status: 422, title: 'Unprocessable Entity', detail: e.message }]
      json_response({ errors: errors }, :unprocessable_entity)
    end

    # JSON response with message, status code 401 - unauthorized
    def unauthorized_request(e)
      errors = [{ status: 401, title: 'Unauthorized request', detail: e.message }]
      json_response({ errors: errors }, :unauthorized)
    end

  end
end