class V1::CustomersController < V1::BasicActionsController
  extend V1::SwaggerBasicActionsConfig

  # ===================================================================
  # The rest of the common actions are implemented inside BasicActionsController.
  # - similar to the deprecated Inherited Resources :(
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

  swagger_configure_basic_actions
  #
  # Similar to the controller's actions, the documentation config for
  # the basic actions are refactored inside swagger_basic_actions_config.rb
  # Belows are the documentation configs for custom actions.
  #
  swagger_api :add_project do
    summary "Adds a project to the customer"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :customer_id,:string, :required, "Customer's Id"
    response 200, "Success", :Cusomer
    # response :unauthorized
    response :bad_request
  end

  swagger_api :remove_project do
    summary "Removes a project from the customer"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :customer_id,:string, :required, "Customer's Id"
    response 200, "Success", :Cusomer
    # response :unauthorized
    response :bad_request
  end
end