class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def render_error(message, status = :internal_server_error)
    render(json: {error: message}, status: status) and return
  end

  def render_success(message, status = :ok)
    render(json: message, status: status) and return
  end
end
