class V1::StoragesController < ApplicationController
  include V1::BasicActions
  extend Searchable
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  # ===================================================================
  # The rest of the common actions are implemented inside BasicAtions.
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create
    super(:access_key, :access_password, :customer_id)
  end

  private

  def set_klass; V1::BasicActions.set_klass(:storage); end

  swagger_configure_basic_actions
end