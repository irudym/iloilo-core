class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :active_quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
