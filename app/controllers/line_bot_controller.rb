class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]

  def callback
    body = request.body.read
    signature = request.headers['X-Line-Signature']

    unless LINE_CLIENT.validate_signature(body, signature)
      head :bad_request
        return
    end

    events = LINE_CLIENT.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        handle_text_message(event)
      when Line::Bot::Event::Postback
        handle_postback(event)
      end
    end

    head :ok
  end

  def handle_text_message(event)
    user_id = event['source']['userId']
    message = event.message['text']

    if message == '心理測驗'
        start_test(user_id)
    else
        reply_message(user_id, '請輸入「心理測驗」即可開始測驗')
    end
  end

  def reply_message(user_id, text)
    message = {
        type: 'text',
        text: text
    }
    response = LINE_CLIENT.push_message(user_id, message)

    if response.code != 200
        Rails.logger.error("錯誤訊息: #{response.body}")
    end
  end

  def start_test(user_id)
    questions = Question.order(:id)
 
    return reply_message(user_id, '目前尚無心理測驗') if Question.none?
 
    result = Result.create(user_id: , answers: {})
    send_question_to_user(user_id, questions.first, result)
  end

  def send_question_to_user(user_id, question, result)
    message = {
      type: 'template',
      altText: question.title,
      template: {
        type: 'buttons',
        text: question.title,
        actions: [
          { 
            type: 'postback',
            label: question.option_1,
            data: "question_id=#{question.id}&answer=#{question.value_1}&result_id=#{result.id}" 
          },
          { 
            type: 'postback',
            label: question.option_2,
            data: "question_id=#{question.id}&answer=#{question.value_2}&result_id=#{result.id}"
          }
        ]
      }
    }

    response = LINE_CLIENT.push_message(user_id, message)

    if response.code != 200
        Rails.logger.error("錯誤訊息: #{response.body}")
    end
  end

  def handle_postback(event)
    data = Rack::Utils.parse_nested_query(event['postback']['data'])
    # 解析 URL 查詢字串，並轉換為雜湊（Hash）物件

    result = Result.find(data['result_id'])
    question_id = data['question_id']
    answer = data['answer']
 
    result.answers[question_id] = answer
    result.save
 
    next_question = Question.where('id > ?', question_id).order(:id).first

    if next_question.present?
      send_question_to_user(event['source']['userId'], next_question, result)
    else
      reply_message(event['source']['userId'], "您的測驗結果是#{result.answers.values.join}")
    end
  end
end