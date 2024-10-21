class Answer < ApplicationRecord
  include Commentable
  
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }
end
