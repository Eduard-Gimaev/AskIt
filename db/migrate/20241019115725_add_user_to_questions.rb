class AddUserToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_reference :questions, :user, null: false, foreign_key: true
  end
end
