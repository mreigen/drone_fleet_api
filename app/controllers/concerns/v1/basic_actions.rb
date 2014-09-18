module V1::BasicActions

  def self.klass(model_name = nil)
    @klass = model_name.to_s.classify.constantize if model_name
    @klass
  end

  def klass
    V1::BasicActions.klass
  end

  def index
    render_success(result: klass.all)
  end

  def show
    guid = params[:id]
    if guid.blank?
      render_error("Missing #{klass}'s id", :bad_request)
    else
      render_success(result: klass.find_by_guid(guid))
    end
  end

  def create(*require_params)
    create_params = {}
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
    if id.blank?
      render_error("Missing #{klass}'s id", :bad_request)
    else
      model_object = klass.find_by_guid(id)
      if model_object.blank?
        render_error("Can't find a #{klass} with id: #{id}", :bad_request)
      else
        model_object.delete
        render_success(result: "The #{klass} with id: #{id} has been deleted")
      end
    end
  end

  def update
    id = params[:id]
    if id.blank?
      render_error("Missing #{klass}'s id", :bad_request)
    else
      model_object = klass.find_by_guid(id)
      if model_object.blank?
        render_error("Can't find a #{klass} with id: #{id}", :bad_request)
      else
        if model_object.update_attributes(klass_params)
          render_success(result: model_object)
        else
          render_error("Couldn't update the #{klass} with id: #{id}", :bad_request)
        end
      end
    end
  end


  protected

  def klass_params
    allowed_keys = klass.allowed_keys_in_params(params)
    params.permit(allowed_keys)
  end

  private

  def create_with_refined_params(create_params)
    return false unless create_params.present?
    model_object = klass.new(create_params)
    model_object.save ? model_object : nil
  end
end