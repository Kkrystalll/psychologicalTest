class AddQuestionSequenceAndCurrentIndexToResults < ActiveRecord::Migration[7.1]
  def change
    add_column :results, :question_sequence, :json, default: []
    add_column :results, :current_index, :integer, default: 0
  end
end
