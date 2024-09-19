module ArticleAPI
  class API < Grape::API
    version 'v1', using: :header, vendor: "article" 
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    prefix :api

    helpers do
      def set_article
        begin
          Article.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error!({ error: "Article not found" }, 404)
        end
      end
    end

    resources :articles do
      # GET /api/articles
      desc "Return list of articles"
      get jbuilder: 'articles/articles' do
        @articles = Article.all
      end

      # POST /api/articles
      desc "Create a new article"
      params do
        requires :title, type: String, desc: "Title of the article"
        requires :text, type: String, desc: "Content of the article"
      end
      post jbuilder: 'articles/article' do
        @article = Article.new(params)
        @article.user = User.first
        
        if @article.save
          @article
          @status = 201
          @message = "Article created successfully"
        else
          error!({ errors: @article.errors.full_messages }, 400)
        end
      end

      route_param :id do
        # GET /api/articles/:id
        desc "Return the article"
        get jbuilder: 'articles/article' do
          @article = set_article
        end 

        # PATCH /api/articles/:id
        desc "Update the article"
        params do
          optional :title, type: String, desc: "Updated title of the article"
          optional :text, type: String, desc: "Updated content of the article"
        end
        patch jbuilder: "articles/article" do
          @article = set_article

          if @article.update(params)
            @status = 200
            @message = "Article updated successfully"
            @article
          else
            error!({ errors: @article.errors.full_messages }, 400)
          end
        end

        #  DELETE /api/articles/:id
        desc "Delete the article"
        delete jbuilder: "articles/article" do
          @article = set_article
          @status = 200
          @message = "Article deleted successfully"
          @article.destroy
        end 
        
      end
    end
  end
end
