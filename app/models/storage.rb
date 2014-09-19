class Storage
  include Mongoid::Document
  extend Searchable

  field :guid,              type: String
  field :access_key,        type: String
  field :access_password,   type: String
  field :customer_id,       type: String # customer's guid

  validates :access_key,        presence: true
  validates :access_password,   presence: true
  validates :customer_id,       presence: true

  attr_readonly :guid

  before_create :set_guid

  def set_guid
    self.guid = 'S' + SecureRandom.hex
  end
end
