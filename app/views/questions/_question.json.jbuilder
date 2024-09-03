json.extract! question, :id, :title, :option_1, :option_2, :value_1, :value_2, :created_at, :updated_at
json.url question_url(question, format: :json)
