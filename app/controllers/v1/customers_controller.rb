class V1::CustomersController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  # ===================================================================
  # The rest of the common actions are implemented inside BasicAtions.
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create; super(:name); end

  def show; super(sub_set: :projects); end

  def add_project
    project_id  = params[:project_id]
    customer_id = params[:customer_id]
    if project_id.blank? || customer_id.blank?
      render_error "Either project_id or customer_id is blank"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    customer = Customer.find_by_guid(customer_id)
    if customer.blank?
      render_error "Can't find customer with customer_id: #{customer_id}"
      return
    end

    project.customer = customer

    if project.save
      render_success result: {customer: customer, projects: customer.projects}
    else
      render_error "Can't add project_id #{project_id} to customer_id #{customer_id}"
    end
  end

  def remove_project
    project_id  = params[:project_id]
    customer_id = params[:customer_id]
    if project_id.blank? || customer_id.blank?
      render_error "Either project_id or customer_id is blank"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    customer = Customer.find_by_guid(customer_id)
    if customer.blank?
      render_error "Can't find customer with customer_id: #{customer_id}"
      return
    end

    customer.projects.delete_if {|p| p == project}

    if customer.save
      render_success result: {customer: customer, projects: customer.projects}
    else
      render_error "Can't add project_id #{project_id} to customer_id #{customer_id}"
    end
  end

  private

  def set_klass; V1::BasicActions.set_klass(:customer); end

  swagger_configure_basic_actions
end