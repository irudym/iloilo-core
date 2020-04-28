class CreateVuexloggers < ActiveRecord::Migration[6.0]
  def change
    create_table :vuexloggers do |t|
      t.text :log
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
