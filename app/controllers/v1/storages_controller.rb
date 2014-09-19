class V1::StoragesController < ApplicationController
  include V1::BasicActions
  extend Searchable

  V1::BasicActions.klass(:storage)

  def create
    super(:access_key, :access_password, :customer_id)
  end
end