class V1::StoragesController < V1::BasicActionsController
  extend Searchable
  extend V1::SwaggerBasicActionsConfig

  # ===================================================================
  # The rest of the common actions are implemented inside BasicActionsController.
  # - similar to the deprecated Inherited Resources :(
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create
    super(:access_key, :access_password, :customer_id)
  end

  private

  swagger_configure_basic_actions
end