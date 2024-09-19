class AddUserToArticle < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :user, foreign_key: true, index: true, on_delete: :cascade
  end
end
