class V1::FlightsController < ApplicationController
  include V1::BasicActions
  extend Searchable

  before_filter :set_klass

  V1::BasicActions.set_klass(:flight)

  def create; super(:project_id, :craft_id); end

  private

  def set_klass; V1::BasicActions.set_klass(:flight); end
end