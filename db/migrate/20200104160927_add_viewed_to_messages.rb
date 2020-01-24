class AddViewedToMessages < ActiveRecord::Migration[5.2]
  def change
  	add_column :messages, :viewed, :boolean, default: false
  end
end
