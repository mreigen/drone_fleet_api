class Craft
  include Mongoid::Document
  extend Paramable
  extend Searchable

  field :guid,        type: String
  field :type,        type: String
  field :ceiling,     type: Float
  field :max_speed,   type: Float

  # more craft's data, could be other child models inherit from this

  validates :type, presence: true
  # TODO: other validations

  before_create :set_guid

  attr_readonly :guid

  belongs_to :project

  def set_guid
    self.guid = "A#{SecureRandom.hex}"
  end
end
