class V1::CustomersController < ApplicationController
  include V1::BasicActions

  V1::BasicActions.klass(:customer)

  def create
    super(:name)
  end
end