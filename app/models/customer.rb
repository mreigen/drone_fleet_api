class Customer
  include Mongoid::Document

  field :guid, type: String
  field :name, type: String

  before_create :set_guid

  def set_guid
    self.guid = 'C' + SecureRandom.hex
  end
end
