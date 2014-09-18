class Craft
  include Mongoid::Document

  field :guid,        type: String
  field :type,        type: String
  field :ceiling,     type: Float
  field :max_speed,   type: Float

  # more craft's data, could be other child models inherit from this

  before_create :set_guid

  def self.find_by_guid(guid)
    where(guid: guid)
  end

  def set_guid
    self.guid = 'A' + SecureRandom.hex
  end
end
