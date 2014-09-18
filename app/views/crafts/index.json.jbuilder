json.array!(@crafts) do |craft|
  json.extract! craft, :id, :rspec
  json.url craft_url(craft, format: :json)
end
