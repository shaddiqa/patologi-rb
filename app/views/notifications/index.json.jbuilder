json.data do
  json.array! @notifications do |q|
    json.id q.id
    json.message q.message
    json.created_at q.created_at
  end
end