class V1::CustomersController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  def create; super(:name); end

  def show; super(sub_set: :projects); end

  def add_project
    project   = Project.find_by_guid(params[:project_id])
    customer  = Customer.find_by_guid(params[:customer_id])
    project.customer = customer
    project.save
    render_success result: {customer: customer, projects: customer.projects}
  end

  private

  def set_klass; V1::BasicActions.set_klass(:project); end

  swagger_configure_basic_actions
end