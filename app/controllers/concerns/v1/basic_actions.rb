module V1::BasicActions

  # to set the model's class which is to be used in this controller
  def self.set_klass(model_name)
    @klass = model_name.to_s.classify.constantize
  end

  def self.get_klass; @klass; end

  # for internal use, for code aesthetic
  def klass
    V1::BasicActions.klass
  end

  def index
    render_success(result: klass.all)
  end

  def show(sub_set_hsh = nil)
    guid = params[:id]
    if guid.blank?
      render_error("Missing #{klass}'s id", :bad_request)
    else
      model_object = klass.find_by_guid(guid)
      data = {result: model_object}
      # if there is a sub_set passed in, include the sub_set (children) data
      # in the response
      if sub_set_hsh.present?
        sub_set_klass = sub_set_hsh[:sub_set].to_s.classify.constantize
        data.merge!(sub_set_hsh[:sub_set].to_sym => model_object.children)
      end
      render_success(data)
    end
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
    if id.blank?
      render_error("Missing #{klass}'s id", :bad_request)
      return
    end

    if model_object = klass.find_by_guid(id)
      if model_object.delete
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
    if id.blank?
      render_error("Missing #{klass}'s id", :bad_request)
      return
    end

    if model_object = klass.find_by_guid(id)
      if model_object.update_attributes(klass_params)
        render_success(result: model_object)
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

  def create_with_refined_params(create_params)
    return false unless create_params.present?
    model_object = klass.new(create_params)
    model_object.save ? model_object : nil
  end
end