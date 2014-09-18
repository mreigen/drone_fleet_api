class Project
  include Mongoid::Document

  field :guid,        type: String
  field :type,        type: String
  field :craft_id,    type: String # craft's guid

  before_create :set_guid

  def set_guid
    self.guid = 'P' + SecureRandom.hex
  end
end
