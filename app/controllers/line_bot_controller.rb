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

    if response.code != "200"
        Rails.logger.error("錯誤訊息: #{response.body}")
    end
  end

  def start_test(user_id)
    # 取得所有有題目的分類
    categories = Category.joins(:questions).distinct.order(:order)

    return reply_message(user_id, '目前尚無心理測驗') if categories.empty?

    # 從每個分類隨機抽一題，產生題目序列
    question_sequence = categories.map { |cat| cat.questions.sample.id }

    # 打亂題目順序
    question_sequence.shuffle!

    # 建立 result 並儲存 question_sequence 和 current_index
    result = Result.create(
      user_id: user_id,
      answers: {},
      question_sequence: question_sequence,
      current_index: 0
    )

    # 發送第一題
    first_question = Question.find(question_sequence[0])
    send_question_to_user(user_id, first_question, result)
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

    if response.code != "200"
        Rails.logger.error("錯誤訊息: #{response.body}")
    end
  end

  def handle_postback(event)
    data = Rack::Utils.parse_nested_query(event['postback']['data'])
    # 解析 URL 查詢字串，並轉換為雜湊（Hash）物件

    result = Result.find(data['result_id'])
    question_id = data['question_id'].to_i
    answer = data['answer']

    # 以 category_id 為 key 儲存答案
    question = Question.find(question_id)
    result.answers[question.category_id.to_s] = answer

    # 更新 current_index
    result.current_index += 1
    result.save

    # 用 question_sequence 和 current_index 判斷下一題
    if result.current_index < result.question_sequence.length
      next_question_id = result.question_sequence[result.current_index]
      next_question = Question.find(next_question_id)
      send_question_to_user(event['source']['userId'], next_question, result)
    else
      # 結果顯示改為按分類 order 排序答案後串接
      sorted_answers = Category.order(:order).map do |cat|
        result.answers[cat.id.to_s]
      end.compact.join

      reply_message(event['source']['userId'], "您的測驗結果是#{sorted_answers}")
    end
  end
end