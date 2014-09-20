class V1::CustomersController < ApplicationController
  include V1::BasicActions

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

  private def set_klass; V1::BasicActions.set_klass(:customer); end

  swagger_controller :customers, "Customer Management"

  swagger_api :index do
    summary "Fetches all customers"
    notes "This lists all the active customers"
    response 200, "Success", :Customers
    # response :unauthorized
    response :bad_request
  end

  swagger_api :show do
    summary "Fetches a single customer"
    param :path, :id, :string, :required, "customer Id"
    response 200, "Success", :customer
    # response :unauthorized
    response :bad_request
  end

  swagger_api :create do
    summary "Creates a new customer"
    param :form, :name, :string, :required, "customer name"
    response 200, "Success", :customer
    # response :unauthorized
    response :bad_request
  end

  swagger_api :update do
    summary "Updates an existing customer"
    param :path, :id, :string, :required, "User Id"
    param :form, :name, :string, :optional, "customer name"
    response 200, "Success", :customer
    # response :unauthorized
    response :bad_request
  end

  swagger_api :destroy do
    summary "Deletes an existing customer"
    param :path, :id, :string, :required, "customer Id"
    response 200, "Success", :customer
    # response :unauthorized
    response :bad_request
  end
end