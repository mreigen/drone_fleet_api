class V1::CraftsController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  # ===================================================================
  # The rest of the common actions are implemented inside BasicAtions.
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create; super(:type, :max_speed); end

  def add_flight
    # TODO
  end

  def remove_flight
    # TODO
  end

  private

  def set_klass; V1::BasicActions.set_klass(:craft); end

  swagger_configure_basic_actions
  #
  # Similar to the controller's actions, the documentation config for
  # the basic actions are refactored inside swagger_basic_actions_config.rb
  # Belows are the documentation configs for custom actions.
  #
  swagger_api :add_project do
    # TODO
  end

  swagger_api :remove_project do
    # TODO
  end
end