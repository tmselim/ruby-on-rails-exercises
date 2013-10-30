json.array!(@frames) do |frame|
  json.extract! frame, :name, :brand_id
  json.url frame_url(frame, format: :json)
end
