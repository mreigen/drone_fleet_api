class Craft
  include Mongoid::Document
  extend Paramable

  field :guid,        type: String
  field :type,        type: String
  field :ceiling,     type: Float
  field :max_speed,   type: Float

  # more craft's data, could be other child models inherit from this

  before_create :set_guid

  attr_readonly :guid

  def self.find_by_guid(guid)
    where(guid: guid).first
  end

  def set_guid
    self.guid = 'A' + SecureRandom.hex
  end
end
