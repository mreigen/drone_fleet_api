module V1::SwaggerBasicActionsConfig
  include Klassable

  def swagger_configure_basic_actions
    klass_name  = klass_name_from_controller_class(self)
    klass       = klass_name.constantize

    swagger_controller :"#{klass_name}s", "#{klass_name} Management"

    swagger_api :index do
      summary "Fetches all #{klass_name}s"
      notes "This lists all active #{klass_name}s"
      response 200, "Success", :"#{klass_name}s"
      # response :unauthorized
      response :bad_request
    end

    swagger_api :show do
      summary "Fetches a single #{klass_name}"
      param :path, :id, :string, :required, "#{klass_name} Id"
      response 200, "Success", klass
      # response :unauthorized
      response :bad_request
    end

    swagger_api :create do
      summary "Creates a new #{klass_name}"
      case klass_name
      when "Craft"
        param :form, :type,       :string,  :required, "#{klass_name}'s type"
        param :form, :max_speed,  :float,   :required, "#{klass_name}'s max_speed"
      when "Project"
        param :form, :type, :string, :required, "#{klass_name}'s type"
      when "Flight"
        param :form, :project_id, :string,  :required, "#{klass_name}'s project Id"
        param :form, :craft_id,   :float,   :required, "#{klass_name}'s craft Id"
      when "Storage"
        param :form, :access_key,       :string,  :required, "#{klass_name}'s access_key"
        param :form, :access_password,  :string,  :required, "#{klass_name}'s access_password"
        param :form, :customer_id,      :string,  :required, "#{klass_name}'s customer Id"
      else
        param :form, :name, :string, :required, "#{klass_name}'s name"
      end
      response 200, "Success", klass
      # response :unauthorized
      response :bad_request
    end

    swagger_api :update do
      summary "Updates an existing #{klass_name}"
      param :path, :id, :string, :required, "User Id"
      param :form, :name, :string, :optional, "#{klass_name} name"
      response 200, "Success", klass
      # response :unauthorized
      response :bad_request
    end

    swagger_api :destroy do
      summary "Deletes an existing #{klass_name}"
      param :path, :id, :string, :required, "#{klass_name} Id"
      response 200, "Success", klass
      # response :unauthorized
      response :bad_request
    end
  end

end