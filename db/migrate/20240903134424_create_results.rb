class CreateResults < ActiveRecord::Migration[7.1]
  def change
    create_table :results do |t|
      t.json :answers
      t.string :user_id

      t.timestamps
    end
  end
end
