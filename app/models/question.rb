class Question < ApplicationRecord
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  scope :all_by_tags, ->(tag_ids, page, per_page) do
    questions = includes(:user, :question_tags, :tags).order(created_at: :desc)
    questions = questions.joins(:question_tags).where(question_tags: { tag_id: tag_ids }) if tag_ids.present?
    questions = questions.distinct
    questions = questions.page(page).per(per_page)
  end

end
