module Searchable
  def find_by_guid(guid)
    where(guid: guid).first
  end
end