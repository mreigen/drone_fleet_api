class Customer
  include Mongoid::Document
  extend Searchable

  field :guid, type: String
  field :name, type: String

  validates :name, presence: true, uniqueness: true

  before_create :set_guid

  def set_guid
    self.guid = 'C' + SecureRandom.hex
  end
end
