class V1::CraftsController < ApplicationController
  include V1::BasicActions

  V1::BasicActions.klass(:craft)

  def create
    super(:type, :max_speed)
  end
end