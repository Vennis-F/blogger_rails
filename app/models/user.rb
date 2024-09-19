class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_secure_password
end