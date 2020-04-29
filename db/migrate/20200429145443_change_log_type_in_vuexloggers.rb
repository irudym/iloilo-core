class ChangeLogTypeInVuexloggers < ActiveRecord::Migration[6.0]
  def change
    change_column :vuexloggers, :log, :binary
  end
end
