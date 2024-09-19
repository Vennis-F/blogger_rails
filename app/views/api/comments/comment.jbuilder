json.status @status if @status
json.message @message if @message
json.comment do
  json.(@comment, :id, :commenter, :body, :article_id)
end