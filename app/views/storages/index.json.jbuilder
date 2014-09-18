json.array!(@storages) do |storage|
  json.extract! storage, :id
  json.url storage_url(storage, format: :json)
end
