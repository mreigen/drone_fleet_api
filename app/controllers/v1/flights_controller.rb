class V1::FlightsController < ApplicationController
  include V1::BasicActions
  extend Searchable

  V1::BasicActions.klass(:flight)

  def create
    super(:project_id, :craft_id)
  end
end