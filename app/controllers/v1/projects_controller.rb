class V1::ProjectsController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  # ===================================================================
  # The rest of the common actions are implemented inside BasicAtions.
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create; super(:type); end

  def show; super(sub_set: :crafts); end

  def add_craft
    craft_id    = params[:craft_id]
    project_id  = params[:project_id]
    if craft_id.blank? || project_id.blank?
      render_error "Either craft_id or project_id is blank"
      return
    end

    craft = Craft.find_by_guid(craft_id)
    if craft.blank?
      render_error "Can't find craft with craft_id: #{craft_id}"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    craft.project = project

    if craft.save
      render_success result: {project: project, crafts: project.crafts}
    else
      render_error "Can't add craft_id #{craft_id} to project_id #{project_id}"
    end
  end # add_craft

  def remove_craft
    craft_id  = params[:craft_id]
    project_id = params[:project_id]
    if project_id.blank? || craft_id.blank?
      render_error "Either craft_id or project_id is blank"
      return
    end

    craft = Craft.find_by_guid(craft_id)
    if craft.blank?
      render_error "Can't find craft with craft_id: #{craft_id}"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    project.crafts.delete_if {|c| c == craft}

    if project.save
      render_success result: {project: project, crafts: project.crafts}
    else
      render_error "Can't remove craft_id #{craft_id} from project_id #{project_id}"
    end
  end # remove_craft

  def add_flight
    flight_id    = params[:flight_id]
    project_id  = params[:project_id]
    if flight_id.blank? || project_id.blank?
      render_error "Either flight_id or project_id is blank"
      return
    end

    flight = Flight.find_by_guid(flight_id)
    if flight.blank?
      render_error "Can't find flight with flight_id: #{flight_id}"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    flight.project = project

    if flight.save
      render_success result: {project: project, flights: project.flights}
    else
      render_error "Can't add flight_id #{flight_id} to project_id #{project_id}"
    end
  end # add_flight

  def remove_flight
    flight_id  = params[:flight_id]
    project_id = params[:project_id]
    if project_id.blank? || flight_id.blank?
      render_error "Either flight_id or project_id is blank"
      return
    end

    flight = Flight.find_by_guid(flight_id)
    if flight.blank?
      render_error "Can't find flight with flight_id: #{flight_id}"
      return
    end

    project = Project.find_by_guid(project_id)
    if project.blank?
      render_error "Can't find project with project_id: #{project_id}"
      return
    end

    project.flights.delete_if {|f| f == flight}

    if project.save
      render_success result: {project: project, flights: project.flights}
    else
      render_error "Can't remove flight_id #{flight_id} from project_id #{project_id}"
    end
  end # remove_flight

  private

  def set_klass
    V1::BasicActions.set_klass(:project)
  end


  swagger_configure_basic_actions
  #
  # Similar to the controller's actions, the documentation config for
  # the basic actions are refactored inside swagger_basic_actions_config.rb
  # Belows are the documentation configs for custom actions.
  #
  swagger_api :add_craft do
    summary "Adds a craft to the project"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :craft_id,   :string, :required, "Craft's Id"
    response 200, "Success", :Project
    # response :unauthorized
    response :bad_request
  end

  swagger_api :remove_craft do
    summary "Removes a craft from the project"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :craft_id,   :string, :required, "Craft's Id"
    response 200, "Success", :Project
    # response :unauthorized
    response :bad_request
  end

  swagger_api :add_flight do
    summary "Adds a flight to the project"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :flight_id,  :string, :required, "Flight's Id"
    response 200, "Success", :Project
    # response :unauthorized
    response :bad_request
  end

  swagger_api :remove_flight do
    summary "Removes a flight from the project"
    param :path, :project_id, :string, :required, "Project's Id"
    param :path, :flight_id,  :string, :required, "Flight's Id"
    response 200, "Success", :Project
    # response :unauthorized
    response :bad_request
  end
end