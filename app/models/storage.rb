class Storage
  include Mongoid::Document

  field :guid,              type: String
  field :access_key,        type: String
  field :access_password,   type: String
  field :customer_id,       type: String # customer's guid

  before_create :set_guid

  def set_guid
    self.guid = 'S' + SecureRandom.hex
  end
end
