class V1::CraftsController < ApplicationController

  respond_to :json

  def index
    render_success(result: Craft.all)
  end

  def show
    guid = params[:id]
    if guid.blank?
      render_error("missing craft's id", :bad_request)
    else
      render_success(result: Craft.find_by_guid(guid))
    end
  end

  def create
    type = params[:type]
    if type.blank?
      render_error("missing craft's type", :bad_request)
    else
      craft = Craft.create(type: type)
      render_success(result: craft)
    end
  end

  def destroy
    id = params[:id]
    if id.blank?
      render_error("missing craft's id", :bad_request)
    else
      craft = Craft.find_by_guid(id)
      if craft.blank?
        render_error("Can't find a craft with id: #{id}", :bad_request)
      else
        craft.delete
        render_success(result: "craft with id: #{id} has been deleted")
      end
    end
  end

  def update
    id = params[:id]
    if id.blank?
      render_error("missing craft's id", :bad_request)
    else
      craft = Craft.find_by_guid(id)
      if craft.blank?
        render_error("Can't find a craft with id: #{id}", :bad_request)
      else
        if craft.update_attributes(craft_params)
          render_success(result: craft)
        else
          render_error("Couldn't update craft with id: #{id}", :bad_request)
        end
      end
    end
  end

  private

  def craft_params
    allowed_keys = Craft.allowed_keys_in_params(params)
    params.permit(allowed_keys)
  end
end