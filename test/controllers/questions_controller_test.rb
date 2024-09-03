require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get questions_url
    assert_response :success
  end

  test "should get new" do
    get new_question_url
    assert_response :success
  end

  test "should create question" do
    assert_difference("Question.count") do
      post questions_url, params: { question: { option_1: @question.option_1, option_2: @question.option_2, title: @question.title, value_1: @question.value_1, value_2: @question.value_2 } }
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_url(@question)
    assert_response :success
  end

  test "should update question" do
    patch question_url(@question), params: { question: { option_1: @question.option_1, option_2: @question.option_2, title: @question.title, value_1: @question.value_1, value_2: @question.value_2 } }
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete question_url(@question)
    end

    assert_redirected_to questions_url
  end
end
