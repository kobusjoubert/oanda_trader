json.array! @symbols do |symbol|
  json.symbol symbol.name
  json.full_name symbol.name
  json.description symbol.description
  json.exchange symbol.exchange
  json.type symbol.type
end
