# # Создание пользователей
# 10.times do
#   name = Faker::Name.name
#   email = Faker::Internet.email
#   password = "TeC1!"
#   User.create!(name: name, email: email, password: password, password_confirmation: password)
# end

# # Создание вопросов и ответов
# 30.times do
#   title = Faker::Hipster.sentence(word_count: 3)
#   body = Faker::Hipster.paragraph(sentence_count: 3)
#   user = User.order('RANDOM()').first # Выбираем случайного пользователя
#   question = Question.create!(title: title, body: body, user: user)

#   3.times do
#     answer_body = Faker::Hipster.paragraph(sentence_count: 2)
#     answer_user = User.order('RANDOM()').first # Выбираем случайного пользователя для ответа
#     Answer.create!(body: answer_body, question: question, user: answer_user)
#   end
# end

# 30.times do
#   title = Faker::Hipster.word
#   Tag.create!(title: title)
# end