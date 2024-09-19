json.articles @articles do |a|
  json.article do
    json.(a, :id, :title, :text)
  end
end

