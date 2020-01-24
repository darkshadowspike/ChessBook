class AddViewedToPosts < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :viewed, :boolean, default: false
  end
end
