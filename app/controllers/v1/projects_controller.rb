class V1::ProjectsController < ApplicationController
  include V1::BasicActions

  V1::BasicActions.klass(:project)

  def create
    super(:type, :craft_id)
  end
end