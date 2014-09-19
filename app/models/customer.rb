class Customer
  include Mongoid::Document
  extend Searchable

  field :guid, type: String
  field :name, type: String

  validates :name, presence: true, uniqueness: true

  before_create :set_guid

  attr_readonly :guid

  has_many :projects

  def set_guid
    self.guid = 'C' + SecureRandom.hex
  end

  def children
    self.projects
  end
end
