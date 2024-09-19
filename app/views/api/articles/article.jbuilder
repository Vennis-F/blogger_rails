json.status @status if @status
json.message @message if @message
json.article do
  json.(@article, :id, :title, :text)
end