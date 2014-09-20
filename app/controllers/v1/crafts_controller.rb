class V1::CraftsController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  def create; super(:type, :max_speed); end

  private

  def set_klass; V1::BasicActions.set_klass(:craft); end

  swagger_configure_basic_actions
end