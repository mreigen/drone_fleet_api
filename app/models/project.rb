class Project
  include Mongoid::Document
  extend Paramable
  extend Searchable

  field :guid,        type: String
  field :type,        type: String
  field :craft_id,    type: String # craft's guid

  validates :type,      presence: true

  attr_readonly :guid

  before_create :set_guid

  belongs_to :customer
  has_many   :crafts
  has_many   :flights

  def set_guid
    self.guid = "P#{SecureRandom.hex}"
  end

  def children
    self.crafts
  end
end
