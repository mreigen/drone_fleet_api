class V1::StoragesController < ApplicationController
  include V1::BasicActions
  extend Searchable

  before_filter :set_klass

  def create
    super(:access_key, :access_password, :customer_id)
  end

  def set_klass; V1::BasicActions.set_klass(:storage); end
end