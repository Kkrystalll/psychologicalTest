class AddCategoryToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :category, foreign_key: true
  end
end
