class V1::CraftsController < ApplicationController
  include V1::BasicActions

  before_filter :set_klass

  def create; super(:type, :max_speed); end

  private

  def set_klass; V1::BasicActions.set_klass(:craft); end
end