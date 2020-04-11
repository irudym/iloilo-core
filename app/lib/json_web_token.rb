# JWT singleton
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = Rails.application.secret_key_base

  def self.encode(payload, exp = 90.days.from_now)
    # set expiry to 90 days from creation time
    payload[:exp] = exp.to_i

    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body

    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # rais custom error to be handled by a custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end
end