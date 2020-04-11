module Response

  # define json response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  # define json response with particular fields
  # status is always :ok
  def json_fields_response(object, status, *fields)
    response = fields.inject({}) do |acc, elem|
      acc.update(elem => object.send(elem))
    end
    render json: response, status: status
  end
end