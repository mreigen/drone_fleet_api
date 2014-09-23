class V1::ProjectsController < ApplicationController
  include V1::BasicActions
  extend  V1::SwaggerBasicActionsConfig

  before_filter :set_klass

  # ===================================================================
  # The rest of the common actions are implemented inside BasicAtions.
  # Only actions that are taylored to the need of this controller
  # are implemented here.
  # ===================================================================

  def create; super(:type, :craft_id); end

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
      render_error "Can't add craft_id #{craft_id} to craft_id #{craft_id}"
    end
  end

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
      render_error "Can't add craft_id #{craft_id} to craft_id #{craft_id}"
    end
  end

  private

  def set_klass
    V1::BasicActions.set_klass(:project)
  end

  swagger_configure_basic_actions
end