class V1::BasicActionsController < ApplicationController

  before_action :set_model_object, except: [:create]

  def index
    render_success(result: klass.all)
  end

  def show(sub_set_hsh = nil)
    if @model_object.blank?
      render_error("Can't find #{klass} with id: #{params[:id]}")
      return
    end
    data = {result: @model_object}
    # if there is a sub_set passed in, include the sub_set (children) data
    # in the response
    if sub_set_hsh.present?
      sub_set_klass = sub_set_hsh[:sub_set].to_s.classify.constantize
      data.merge!(sub_set_hsh[:sub_set].to_sym => @model_object.children)
    end
    render_success(data)
  end

  def create(*require_params)
    create_params = {}
    # each model has a different set of require fields at creation
    # makes sure they present
    require_params.each do |rp|
      unless params.has_key?(rp)
        render_error("Missing #{klass}'s #{rp}", :bad_request)
        return
      end
      create_params[rp.to_sym] = params[rp.to_sym]
    end

    if model_object = create_with_refined_params(create_params)
      render_success(result: model_object)
    else
      render_error("Failed to create a new #{klass}", :bad_request)
    end
  end

  def destroy
    id = params[:id]
    if @model_object
      if @model_object.delete
        render_success(result: "The #{klass} with id: #{id} has been deleted")
      else
        render_error("Failed to delete a #{klass} with #{id}", :bad_request)
      end
    else
      render_error("Can't find a #{klass} with id: #{id}", :bad_request)
    end
  end

  def update
    id = params[:id]
    if @model_object
      if @model_object.update_attributes(klass_params)
        render_success(result: @model_object)
      else
        render_error("Couldn't update the #{klass} with id: #{id}", :bad_request)
      end
    else
      render_error("Can't find a #{klass} with id: #{id}", :bad_request)
    end
  end

  protected

  def klass_params
    allowed_keys = klass.allowed_keys_in_params(params)
    params.permit(allowed_keys)
  end

  private

  def klass; @klass; end
  def klass_name; @klass_name; end

  def set_model_object
    @klass_name  = self.class.to_s.gsub(/V.+::/,"").gsub(/Controller$/,"").singularize.classify
    @klass       = @klass_name.constantize

    @model_object = @klass.find_by_guid(params[:id])
  end

  def create_with_refined_params(create_params)
    return false unless create_params.present?
    model_object = klass.new(create_params)
    model_object.save ? model_object : nil
  end

end