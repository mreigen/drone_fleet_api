class V1::ProjectsController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  def create; super(:type, :craft_id); end

  def show; super(sub_set: :crafts); end

  private

  def set_klass
    V1::BasicActions.set_klass(:project)
  end

  swagger_configure_basic_actions
end