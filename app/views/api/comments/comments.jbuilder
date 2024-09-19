json.comments @comments do |c|
  json.comment do
    json.(c, :id, :commenter, :body, :article_id)
  end
end

