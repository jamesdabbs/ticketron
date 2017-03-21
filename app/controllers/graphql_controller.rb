class GraphqlController < ApiController
  def execute
    query     = params[:query]
    variables = ensure_hash params[:variables]

    user   = current_user
    user ||= User.first if Rails.env.development?

    context = {
      user:       user.try(:to_model),
      container:  container
    }

    result = TicketronSchema.execute query, variables: variables, context: context
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
