class Flight
  include Mongoid::Document

  field :guid,        type: String
  field :project_id,  type: String # proejct's guid
  field :craft_id,    type: String # craft's guid
  field :avg_speed,   type: Float
  field :avg_height,  type: Float

  # ....
  # more telemetry data

  before_create :set_guid

  def set_guid
    self.guid = 'F' + SecureRandom.hex
  end
end
