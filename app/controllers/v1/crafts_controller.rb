class V1::CraftsController < ApplicationController

  respond_to :json

  def index
    render json: {yo: :empty}
  end

  def show
    guid = params[:guid]
    # render_error("missing craft's id", :bad_request) unless guid
    render_success({result: Craft.find_by_guid(guid)})
  end
end