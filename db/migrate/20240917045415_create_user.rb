class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 255
      t.string :email, null: false, limit: 255, unique: true
      t.string :password_digest, null: false, limit: 255
    end
  end
end
