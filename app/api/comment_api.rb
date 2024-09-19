module CommentAPI
  class API < Grape::API
    version 'v1', using: :header, vendor: 'comment'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    prefix :api

    helpers do
      def set_article
        begin
          Article.find(params[:article_id])
        rescue ActiveRecord::RecordNotFound
          error!({ error: "Article not found" }, 404)
        end
      end

      def set_comment
        article = set_article

        begin
          comment = article.comments.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error!({ error: "Comment Not found" }, 404)
        end
      end
    end

    resources :articles do
      route_param :article_id do
        resources :comments do
          # GET api/articles/:article_id/comments
          desc "Return list of comments for a specific article"
          get jbuilder: "comments/comments" do
            article = set_article
            @comments =  article.comments
          end

          # GET api/articles/:article_id/comments/:id
          desc "Get a comment from an article"
          get ':id', jbuilder: "comments/comment" do
            @comment = set_comment
          end

          # POST api/articles/:article_id/comments
          desc "Create a comment for an article"
          params do
            requires :commenter, type: String, desc: "Commenter's name"
            requires :body, type: String, desc: "Comment body"
          end
          post jbuilder: "comments/comment" do
            article = set_article
            @comment = article.comments.new({
              commenter: params[:commenter],
              body: params[:body]
            })

            if @comment.save
              @status = 201
              @message = "Comment created successfully"
              @comment
            else
              error!({ error: @comment.errors.full_messages }, 400)
            end
          end

          # DELETE api/articles/:article_id/comments/:id
          desc "Delete a comment from an article"
          delete ':id', jbuilder: "comments/comment" do
            @comment = set_comment
            @comment.destroy
            @status = 200
            @message = "Comment deleted successfully"
          end
        end
      end
    end
    add_swagger_documentation
  end
end
