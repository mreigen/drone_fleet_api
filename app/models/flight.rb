class Flight
  include Mongoid::Document
  extend Paramable
  extend Searchable

  field :guid,        type: String
  field :project_id,  type: String # project's guid
  field :craft_id,    type: String # craft's guid
  field :avg_speed,   type: Float
  field :avg_height,  type: Float

  # ....
  # more telemetry data

  validates :project_id,  presence: true
  validates :craft_id,    presence: true

  attr_readonly :guid

  belongs_to :craft
  belongs_to :project

  before_create :set_guid

  def set_guid
    self.guid = "F#{SecureRandom.hex}"
  end
end
